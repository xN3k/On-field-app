import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/core_providers.dart';
import '../../data/datasources/location_local_datasource.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/entities/location_ping.dart';
import '../../domain/repositories/location_repository.dart';

part 'location_providers.g.dart';

@riverpod
LocationRemoteDataSource locationRemoteDataSource(Ref ref) =>
    LocationRemoteDataSource(ref.watch(dioProvider));

@riverpod
LocationLocalDataSource locationLocalDataSource(Ref ref) =>
    LocationLocalDataSource(ref.watch(locationBoxProvider));

@riverpod
LocationRepository locationRepository(Ref ref) => LocationRepositoryImpl(
      remote: ref.watch(locationRemoteDataSourceProvider),
      local: ref.watch(locationLocalDataSourceProvider),
      network: ref.watch(networkInfoProvider),
    );

/// Radius filter for the live map's nearby seed, in meters.
/// `null` means "All" (a wide default radius).
@Riverpod(keepAlive: true)
class MapRadiusFilter extends _$MapRadiusFilter {
  @override
  double? build() => null;

  void set(double? radiusMeters) => state = radiusMeters;
}

/// Live team positions for the manager map: seeded from the nearby endpoint,
/// then kept current by `location:update` socket events.
@riverpod
class TeamLocations extends _$TeamLocations {
  @override
  Stream<List<LocationPing>> build() {
    final repo = ref.watch(locationRepositoryProvider);
    final socket = ref.watch(socketServiceProvider);
    final radius = ref.watch(mapRadiusFilterProvider);
    final byUser = <String, LocationPing>{};
    final controller = StreamController<List<LocationPing>>();

    Future<void> seed() async {
      try {
        // Seed around the device position; fall back to a wide net at the
        // last known position when GPS is unavailable.
        var lat = 37.7749, lng = -122.4194;
        try {
          final pos = await Geolocator.getLastKnownPosition() ??
              await Geolocator.getCurrentPosition();
          lat = pos.latitude;
          lng = pos.longitude;
        } catch (_) {}
        final seedList = await repo.nearby(
          lat: lat,
          lng: lng,
          radiusMeters: radius ?? 50000,
        );
        for (final p in seedList) {
          if (p.userId != null) byUser[p.userId!] = p;
        }
      } catch (_) {
        // Live updates still flow even if the seed fails.
      }
      if (!controller.isClosed) controller.add(byUser.values.toList());
    }

    socket.on('location:update', (data) {
      final map = Map<String, dynamic>.from(data as Map);
      final userId = map['userId'] as String?;
      if (userId == null) return;
      byUser[userId] = LocationPing(
        userId: userId,
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
      );
      if (!controller.isClosed) controller.add(byUser.values.toList());
    });

    ref.onDispose(() {
      socket.off('location:update');
      controller.close();
    });

    seed();
    return controller.stream;
  }
}

/// Most recent position for a single worker (manager map bottom sheet).
@riverpod
Future<LocationPing?> latestLocation(Ref ref, String userId) =>
    ref.watch(locationRepositoryProvider).latest(userId);

/// Paged ping history for a worker, accumulated across "Load more" calls.
@riverpod
class LocationHistory extends _$LocationHistory {
  int _page = 1;
  bool _exhausted = false;
  static const _pageSize = 50;

  bool get exhausted => _exhausted;

  @override
  Future<List<LocationPing>> build(String userId) {
    _page = 1;
    _exhausted = false;
    return _fetch(1);
  }

  Future<List<LocationPing>> _fetch(int page) async {
    final items = await ref
        .read(locationRepositoryProvider)
        .history(userId: userId, page: page, limit: _pageSize);
    if (items.length < _pageSize) _exhausted = true;
    return items;
  }

  Future<void> loadMore() async {
    if (_exhausted || state.isLoading) return;
    final current = state.value ?? const <LocationPing>[];
    final next = await _fetch(_page + 1);
    _page++;
    state = AsyncData([...current, ...next]);
  }
}
