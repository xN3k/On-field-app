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

String _$teamLocationsHash() => r'f1b3809cd4b127155933c3c7ef90405499e369fe';

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
