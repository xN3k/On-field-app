// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_status_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Statuses of the recently submitted sync batches, newest first.

@ProviderFor(SyncBatches)
final syncBatchesProvider = SyncBatchesProvider._();

/// Statuses of the recently submitted sync batches, newest first.
final class SyncBatchesProvider
    extends $AsyncNotifierProvider<SyncBatches, List<SyncBatchStatus>> {
  /// Statuses of the recently submitted sync batches, newest first.
  SyncBatchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncBatchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncBatchesHash();

  @$internal
  @override
  SyncBatches create() => SyncBatches();
}

String _$syncBatchesHash() => r'e48ad2059427bf813ffb06ca5d4800cb8a48e993';

/// Statuses of the recently submitted sync batches, newest first.

abstract class _$SyncBatches extends $AsyncNotifier<List<SyncBatchStatus>> {
  FutureOr<List<SyncBatchStatus>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<SyncBatchStatus>>, List<SyncBatchStatus>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SyncBatchStatus>>,
                List<SyncBatchStatus>
              >,
              AsyncValue<List<SyncBatchStatus>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
