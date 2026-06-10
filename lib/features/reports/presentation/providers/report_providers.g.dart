// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reportRemoteDataSource)
final reportRemoteDataSourceProvider = ReportRemoteDataSourceProvider._();

final class ReportRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ReportRemoteDataSource,
          ReportRemoteDataSource,
          ReportRemoteDataSource
        >
    with $Provider<ReportRemoteDataSource> {
  ReportRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ReportRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportRemoteDataSource create(Ref ref) {
    return reportRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportRemoteDataSource>(value),
    );
  }
}

String _$reportRemoteDataSourceHash() =>
    r'876dd25babc536c1ce327c282a111f076e284a84';

@ProviderFor(reportLocalDataSource)
final reportLocalDataSourceProvider = ReportLocalDataSourceProvider._();

final class ReportLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ReportLocalDataSource,
          ReportLocalDataSource,
          ReportLocalDataSource
        >
    with $Provider<ReportLocalDataSource> {
  ReportLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ReportLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportLocalDataSource create(Ref ref) {
    return reportLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportLocalDataSource>(value),
    );
  }
}

String _$reportLocalDataSourceHash() =>
    r'97cc099cae8333d89cfcd7788a2a10819f58ce5f';

@ProviderFor(reportRepository)
final reportRepositoryProvider = ReportRepositoryProvider._();

final class ReportRepositoryProvider
    extends
        $FunctionalProvider<
          ReportRepository,
          ReportRepository,
          ReportRepository
        >
    with $Provider<ReportRepository> {
  ReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReportRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReportRepository create(Ref ref) {
    return reportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportRepository>(value),
    );
  }
}

String _$reportRepositoryHash() => r'b56c8c8088e19a75375de47b05a9279bf42ed673';

/// Live view of the local report queue (drives the sync badge + list).

@ProviderFor(reportQueue)
final reportQueueProvider = ReportQueueProvider._();

/// Live view of the local report queue (drives the sync badge + list).

final class ReportQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Report>>,
          List<Report>,
          Stream<List<Report>>
        >
    with $FutureModifier<List<Report>>, $StreamProvider<List<Report>> {
  /// Live view of the local report queue (drives the sync badge + list).
  ReportQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportQueueHash();

  @$internal
  @override
  $StreamProviderElement<List<Report>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Report>> create(Ref ref) {
    return reportQueue(ref);
  }
}

String _$reportQueueHash() => r'a1e34677f09fe80266a8ab27619eebe1f4903347';

/// Count of not-yet-synced reports.

@ProviderFor(pendingReportCount)
final pendingReportCountProvider = PendingReportCountProvider._();

/// Count of not-yet-synced reports.

final class PendingReportCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Count of not-yet-synced reports.
  PendingReportCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingReportCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingReportCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return pendingReportCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$pendingReportCountHash() =>
    r'8eb1c1d23118521a00b31b72d63875af238a4b3c';

/// Form controller for submitting a report (offline-capable).

@ProviderFor(ReportForm)
final reportFormProvider = ReportFormProvider._();

/// Form controller for submitting a report (offline-capable).
final class ReportFormProvider
    extends $NotifierProvider<ReportForm, AsyncValue<void>> {
  /// Form controller for submitting a report (offline-capable).
  ReportFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportFormHash();

  @$internal
  @override
  ReportForm create() => ReportForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$reportFormHash() => r'70d1c42c4cf7d1009e5dbb4c902f03bb1e9fd39f';

/// Form controller for submitting a report (offline-capable).

abstract class _$ReportForm extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
