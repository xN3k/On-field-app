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
  Future<void> syncPending() async {
    final pending = local.getPending();
    if (pending.isEmpty || !(await network.isOnline)) return;
    try {
      await remote.syncBatch(pending);
      for (final r in pending) {
        await local.put(
          ReportModel.fromEntity(r.copyWith(syncStatus: SyncStatus.synced)),
        );
      }
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
    }
  }

  @override
  int pendingCount() => local.pendingCount();

  @override
  Stream<List<Report>> watchReports() =>
      local.watch().map((list) => list.cast<Report>());
}
