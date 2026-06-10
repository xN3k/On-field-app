import 'package:uuid/uuid.dart';

import '../../../../core/network/network_info.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_local_datasource.dart';
import '../datasources/report_remote_datasource.dart';
import '../models/report_model.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl({
    required this.remote,
    required this.local,
    required this.network,
  });

  final ReportRemoteDataSource remote;
  final ReportLocalDataSource local;
  final NetworkInfo network;

  static const _uuid = Uuid();

  @override
  Future<Report> submitReport({
    required String taskId,
    required Map<String, dynamic> payload,
  }) async {
    // Write-behind: always persist locally first as PENDING.
    var report = ReportModel(
      idempotencyKey: _uuid.v4(),
      taskId: taskId,
      payload: payload,
      syncStatus: SyncStatus.pending,
    );
    await local.put(report);

    if (await network.isOnline) {
      try {
        await remote.submit(report);
        report = ReportModel.fromEntity(
          report.copyWith(syncStatus: SyncStatus.synced),
        );
        await local.put(report);
      } catch (_) {
        // Stays PENDING; SyncCoordinator will retry on reconnect.
      }
    }
    return report;
  }

  @override
  Future<String?> syncPending() async {
    final pending = local.getPending();
    if (pending.isEmpty || !(await network.isOnline)) return null;
    try {
      final batchId = await remote.syncBatch(pending);
      for (final r in pending) {
        await local.put(
          ReportModel.fromEntity(r.copyWith(syncStatus: SyncStatus.synced)),
        );
      }
      return batchId;
    } catch (_) {
      for (final r in pending) {
        await local.put(
          ReportModel.fromEntity(
            r.copyWith(
              syncStatus: SyncStatus.failed,
              retryCount: r.retryCount + 1,
            ),
          ),
        );
      }
      return null;
    }
  }

  @override
  Future<List<Report>> fetchReports({String? taskId, String? userId}) async {
    // Unsynced local reports come first so workers always see their queue.
    final localReports = local
        .getPending()
        .where((r) => taskId == null || r.taskId == taskId)
        .toList();
    if (!(await network.isOnline)) return localReports;
    try {
      final remoteReports =
          await remote.getReports(taskId: taskId, userId: userId);
      final localKeys = localReports.map((r) => r.idempotencyKey).toSet();
      return [
        ...localReports,
        ...remoteReports.where((r) => !localKeys.contains(r.idempotencyKey)),
      ];
    } catch (_) {
      return localReports;
    }
  }

  @override
  Future<Report?> getReport(String id) async {
    if (await network.isOnline) {
      try {
        return await remote.getById(id);
      } catch (_) {
        // Fall back to the local queue below.
      }
    }
    final cached = local.getAll();
    for (final r in cached) {
      if (r.id == id || r.idempotencyKey == id) return r;
    }
    return null;
  }

  @override
  int pendingCount() => local.pendingCount();

  @override
  Stream<List<Report>> watchReports() =>
      local.watch().map((list) => list.cast<Report>());
}
