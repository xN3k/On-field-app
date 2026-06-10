// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationRemoteDataSource)
final locationRemoteDataSourceProvider = LocationRemoteDataSourceProvider._();

final class LocationRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          LocationRemoteDataSource,
          LocationRemoteDataSource,
          LocationRemoteDataSource
        >
    with $Provider<LocationRemoteDataSource> {
  LocationRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<LocationRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationRemoteDataSource create(Ref ref) {
    return locationRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationRemoteDataSource>(value),
    );
  }
}

String _$locationRemoteDataSourceHash() =>
    r'4a64f4565c9d35d0df1593b230ac5fb30eae5d67';

@ProviderFor(locationLocalDataSource)
final locationLocalDataSourceProvider = LocationLocalDataSourceProvider._();

final class LocationLocalDataSourceProvider
    extends
        $FunctionalProvider<
          LocationLocalDataSource,
          LocationLocalDataSource,
          LocationLocalDataSource
        >
    with $Provider<LocationLocalDataSource> {
  LocationLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<LocationLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationLocalDataSource create(Ref ref) {
    return locationLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationLocalDataSource>(value),
    );
  }
}

String _$locationLocalDataSourceHash() =>
    r'4bbac7863e7be5176a01b0eef3a070c2e10f2076';

@ProviderFor(locationRepository)
final locationRepositoryProvider = LocationRepositoryProvider._();

final class LocationRepositoryProvider
    extends
        $FunctionalProvider<
          LocationRepository,
          LocationRepository,
          LocationRepository
        >
    with $Provider<LocationRepository> {
  LocationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationRepository create(Ref ref) {
    return locationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationRepository>(value),
    );
  }
}

String _$locationRepositoryHash() =>
    r'ac958b0ae95752922ca3ecd194f6091e74d9bc3a';

/// Radius filter for the live map's nearby seed, in meters.
/// `null` means "All" (a wide default radius).

@ProviderFor(MapRadiusFilter)
final mapRadiusFilterProvider = MapRadiusFilterProvider._();

/// Radius filter for the live map's nearby seed, in meters.
/// `null` means "All" (a wide default radius).
final class MapRadiusFilterProvider
    extends $NotifierProvider<MapRadiusFilter, double?> {
  /// Radius filter for the live map's nearby seed, in meters.
  /// `null` means "All" (a wide default radius).
  MapRadiusFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapRadiusFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapRadiusFilterHash();

  @$internal
  @override
  MapRadiusFilter create() => MapRadiusFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double?>(value),
    );
  }
}

String _$mapRadiusFilterHash() => r'022c30a0719de9a783e506d799f8915a6750e43b';

/// Radius filter for the live map's nearby seed, in meters.
/// `null` means "All" (a wide default radius).

abstract class _$MapRadiusFilter extends $Notifier<double?> {
  double? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double?, double?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double?, double?>,
              double?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Live team positions for the manager map: seeded from the nearby endpoint,
/// then kept current by `location:update` socket events.

@ProviderFor(TeamLocations)
final teamLocationsProvider = TeamLocationsProvider._();

/// Live team positions for the manager map: seeded from the nearby endpoint,
/// then kept current by `location:update` socket events.
final class TeamLocationsProvider
    extends $StreamNotifierProvider<TeamLocations, List<LocationPing>> {
  /// Live team positions for the manager map: seeded from the nearby endpoint,
  /// then kept current by `location:update` socket events.
  TeamLocationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamLocationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamLocationsHash();

  @$internal
  @override
  TeamLocations create() => TeamLocations();
}

String _$teamLocationsHash() => r'18b7eefca54b22614c0b6178aa2b6b5cae288ed7';

/// Live team positions for the manager map: seeded from the nearby endpoint,
/// then kept current by `location:update` socket events.

abstract class _$TeamLocations extends $StreamNotifier<List<LocationPing>> {
  Stream<List<LocationPing>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<LocationPing>>, List<LocationPing>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<LocationPing>>, List<LocationPing>>,
              AsyncValue<List<LocationPing>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Most recent position for a single worker (manager map bottom sheet).

@ProviderFor(latestLocation)
final latestLocationProvider = LatestLocationFamily._();

/// Most recent position for a single worker (manager map bottom sheet).

final class LatestLocationProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocationPing?>,
          LocationPing?,
          FutureOr<LocationPing?>
        >
    with $FutureModifier<LocationPing?>, $FutureProvider<LocationPing?> {
  /// Most recent position for a single worker (manager map bottom sheet).
  LatestLocationProvider._({
    required LatestLocationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'latestLocationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$latestLocationHash();

  @override
  String toString() {
    return r'latestLocationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LocationPing?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocationPing?> create(Ref ref) {
    final argument = this.argument as String;
    return latestLocation(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LatestLocationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$latestLocationHash() => r'7343ba5dc4aee77f2d14897f6988550ebec16591';

/// Most recent position for a single worker (manager map bottom sheet).

final class LatestLocationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LocationPing?>, String> {
  LatestLocationFamily._()
    : super(
        retry: null,
        name: r'latestLocationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Most recent position for a single worker (manager map bottom sheet).

  LatestLocationProvider call(String userId) =>
      LatestLocationProvider._(argument: userId, from: this);

  @override
  String toString() => r'latestLocationProvider';
}

/// Paged ping history for a worker, accumulated across "Load more" calls.

@ProviderFor(LocationHistory)
final locationHistoryProvider = LocationHistoryFamily._();

/// Paged ping history for a worker, accumulated across "Load more" calls.
final class LocationHistoryProvider
    extends $AsyncNotifierProvider<LocationHistory, List<LocationPing>> {
  /// Paged ping history for a worker, accumulated across "Load more" calls.
  LocationHistoryProvider._({
    required LocationHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'locationHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$locationHistoryHash();

  @override
  String toString() {
    return r'locationHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LocationHistory create() => LocationHistory();

  @override
  bool operator ==(Object other) {
    return other is LocationHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$locationHistoryHash() => r'81ed3ded8a0b5e2d4a405b40268c6a4c846de8a8';

/// Paged ping history for a worker, accumulated across "Load more" calls.

final class LocationHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          LocationHistory,
          AsyncValue<List<LocationPing>>,
          List<LocationPing>,
          FutureOr<List<LocationPing>>,
          String
        > {
  LocationHistoryFamily._()
    : super(
        retry: null,
        name: r'locationHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Paged ping history for a worker, accumulated across "Load more" calls.

  LocationHistoryProvider call(String userId) =>
      LocationHistoryProvider._(argument: userId, from: this);

  @override
  String toString() => r'locationHistoryProvider';
}

/// Paged ping history for a worker, accumulated across "Load more" calls.

abstract class _$LocationHistory extends $AsyncNotifier<List<LocationPing>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<LocationPing>> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<LocationPing>>, List<LocationPing>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<LocationPing>>, List<LocationPing>>,
              AsyncValue<List<LocationPing>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
