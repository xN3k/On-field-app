import 'package:flutter_test/flutter_test.dart';
import 'package:onfield/core/sync/sync_batch_status.dart';

void main() {
  test('SyncBatchStatus parses a full server row', () {
    final status = SyncBatchStatus.fromJson({
      'id': 'batch-123',
      'status': 'processing',
      'itemCount': 10,
      'processedCount': 7,
      'failedCount': 1,
      'error': null,
      'createdAt': '2026-06-10T09:00:00.000Z',
    });

    expect(status.id, 'batch-123');
    expect(status.status, 'PROCESSING');
    expect(status.itemCount, 10);
    expect(status.processedCount, 7);
    expect(status.failedCount, 1);
    expect(status.error, isNull);
    expect(status.createdAt, isNotNull);
  });

  test('SyncBatchStatus defaults missing counts to zero and PENDING', () {
    final status = SyncBatchStatus.fromJson({'id': 'b'});
    expect(status.status, 'PENDING');
    expect(status.itemCount, 0);
    expect(status.processedCount, 0);
    expect(status.failedCount, 0);
  });
}
