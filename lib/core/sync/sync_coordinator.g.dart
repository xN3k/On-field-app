// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_coordinator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Watches connectivity and drains the offline queues (reports + location
/// pings) whenever the device comes back online. Kept alive for the app's
/// lifetime; start it by reading the provider once during bootstrap.

@ProviderFor(SyncCoordinator)
final syncCoordinatorProvider = SyncCoordinatorProvider._();

/// Watches connectivity and drains the offline queues (reports + location
/// pings) whenever the device comes back online. Kept alive for the app's
/// lifetime; start it by reading the provider once during bootstrap.
final class SyncCoordinatorProvider
    extends $AsyncNotifierProvider<SyncCoordinator, void> {
  /// Watches connectivity and drains the offline queues (reports + location
  /// pings) whenever the device comes back online. Kept alive for the app's
  /// lifetime; start it by reading the provider once during bootstrap.
  SyncCoordinatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncCoordinatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncCoordinatorHash();

  @$internal
  @override
  SyncCoordinator create() => SyncCoordinator();
}

String _$syncCoordinatorHash() => r'c4a6ccfa1bb58a28828f43de5363973cd50c7a20';

/// Watches connectivity and drains the offline queues (reports + location
/// pings) whenever the device comes back online. Kept alive for the app's
/// lifetime; start it by reading the provider once during bootstrap.

abstract class _$SyncCoordinator extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
