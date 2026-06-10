import 'dart:async';

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

/// Live team positions for the manager map: seeded from the nearby endpoint,
/// then kept current by `location:update` socket events.
@riverpod
class TeamLocations extends _$TeamLocations {
  @override
  Stream<List<LocationPing>> build() {
    final repo = ref.watch(locationRepositoryProvider);
    final socket = ref.watch(socketServiceProvider);
    final byUser = <String, LocationPing>{};
    final controller = StreamController<List<LocationPing>>();

    Future<void> seed() async {
      try {
        final seedList = await repo.nearby(
          lat: 37.7749,
          lng: -122.4194,
          radiusMeters: 50000,
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
