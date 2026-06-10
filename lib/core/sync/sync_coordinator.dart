import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/location/presentation/providers/location_providers.dart';
import '../../features/reports/presentation/providers/report_providers.dart';
import '../di/core_providers.dart';
import 'sync_status_providers.dart';

part 'sync_coordinator.g.dart';

/// Watches connectivity and drains the offline queues (reports + location
/// pings) whenever the device comes back online. Kept alive for the app's
/// lifetime; start it by reading the provider once during bootstrap.
@Riverpod(keepAlive: true)
class SyncCoordinator extends _$SyncCoordinator {
  @override
  Future<void> build() async {
    final network = ref.watch(networkInfoProvider);

    // Drain once on startup if already online.
    if (await network.isOnline) {
      await _drain();
    }

    final sub = network.onStatusChange.listen((online) {
      if (online) _drain();
    });
    ref.onDispose(sub.cancel);
  }

  Future<void> _drain() async {
    final reportBatch = await ref.read(reportRepositoryProvider).syncPending();
    final locationBatch =
        await ref.read(locationRepositoryProvider).drainBuffer();
    final box = ref.read(syncMetaBoxProvider);
    for (final id in [reportBatch, locationBatch]) {
      if (id != null) await recordBatchId(box, id);
    }
  }

  /// Manual trigger (e.g. pull-to-refresh).
  Future<void> syncNow() => _drain();
}
