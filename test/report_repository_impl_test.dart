import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onfield/core/network/network_info.dart';
import 'package:onfield/features/reports/data/datasources/report_local_datasource.dart';
import 'package:onfield/features/reports/data/datasources/report_remote_datasource.dart';
import 'package:onfield/features/reports/data/models/report_model.dart';
import 'package:onfield/features/reports/data/repositories/report_repository_impl.dart';
import 'package:onfield/features/reports/domain/entities/report.dart';

class _MockRemote extends Mock implements ReportRemoteDataSource {}

class _MockLocal extends Mock implements ReportLocalDataSource {}

class _MockNetwork extends Mock implements NetworkInfo {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late _MockNetwork network;
  late ReportRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(
      const ReportModel(
        idempotencyKey: 'k',
        taskId: 't',
        payload: {},
        syncStatus: SyncStatus.pending,
      ),
    );
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    network = _MockNetwork();
    repo = ReportRepositoryImpl(remote: remote, local: local, network: network);
    when(() => local.put(any())).thenAnswer((_) async {});
  });

  test('offline submit persists locally and stays PENDING', () async {
    when(() => network.isOnline).thenAnswer((_) async => false);

    final report = await repo.submitReport(taskId: 't1', payload: {'n': 1});

    expect(report.syncStatus, SyncStatus.pending);
    verify(() => local.put(any())).called(1);
    verifyNever(() => remote.submit(any()));
  });

  test('online submit syncs and marks SYNCED', () async {
    when(() => network.isOnline).thenAnswer((_) async => true);
    when(() => remote.submit(any())).thenAnswer((_) async {});

    final report = await repo.submitReport(taskId: 't1', payload: {'n': 1});

    expect(report.syncStatus, SyncStatus.synced);
    // Persisted twice: once PENDING, once SYNCED.
    verify(() => local.put(any())).called(2);
  });

  test('syncPending marks queued reports FAILED when the batch throws',
      () async {
    final pending = [
      const ReportModel(
        idempotencyKey: 'k1',
        taskId: 't1',
        payload: {},
        syncStatus: SyncStatus.pending,
      ),
    ];
    when(() => network.isOnline).thenAnswer((_) async => true);
    when(() => local.getPending()).thenReturn(pending);
    when(() => remote.syncBatch(any())).thenThrow(Exception('boom'));

    await repo.syncPending();

    final captured =
        verify(() => local.put(captureAny())).captured.cast<ReportModel>();
    expect(captured.single.syncStatus, SyncStatus.failed);
    expect(captured.single.retryCount, 1);
  });
}
