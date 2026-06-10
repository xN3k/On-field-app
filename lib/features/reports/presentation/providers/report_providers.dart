import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/core_providers.dart';
import '../../data/datasources/report_local_datasource.dart';
import '../../data/datasources/report_remote_datasource.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';

part 'report_providers.g.dart';

@riverpod
ReportRemoteDataSource reportRemoteDataSource(Ref ref) =>
    ReportRemoteDataSource(ref.watch(dioProvider));

@riverpod
ReportLocalDataSource reportLocalDataSource(Ref ref) =>
    ReportLocalDataSource(ref.watch(reportsBoxProvider));

@riverpod
ReportRepository reportRepository(Ref ref) => ReportRepositoryImpl(
      remote: ref.watch(reportRemoteDataSourceProvider),
      local: ref.watch(reportLocalDataSourceProvider),
      network: ref.watch(networkInfoProvider),
    );

/// Live view of the local report queue (drives the sync badge + list).
@riverpod
Stream<List<Report>> reportQueue(Ref ref) =>
    ref.watch(reportRepositoryProvider).watchReports();

/// Count of not-yet-synced reports.
@riverpod
int pendingReportCount(Ref ref) {
  final queue = ref.watch(reportQueueProvider).value ?? const [];
  return queue.where((r) => r.syncStatus != SyncStatus.synced).length;
}

/// Server history merged with the local unsynced queue.
@riverpod
class ReportsList extends _$ReportsList {
  @override
  Future<List<Report>> build({String? taskId, String? userId}) =>
      ref.watch(reportRepositoryProvider).fetchReports(
            taskId: taskId,
            userId: userId,
          );

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(reportRepositoryProvider).fetchReports(
            taskId: taskId,
            userId: userId,
          ),
    );
  }
}

@riverpod
Future<Report?> reportDetail(Ref ref, String id) =>
    ref.watch(reportRepositoryProvider).getReport(id);

/// Form controller for submitting a report (offline-capable).
@riverpod
class ReportForm extends _$ReportForm {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> submit({
    required String taskId,
    required Map<String, dynamic> payload,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(reportRepositoryProvider)
          .submitReport(taskId: taskId, payload: payload);
    });
  }
}
