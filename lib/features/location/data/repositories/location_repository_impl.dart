import '../../../../core/network/network_info.dart';
import '../../domain/entities/location_ping.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';
import '../datasources/location_remote_datasource.dart';
import '../models/location_ping_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl({
    required this.remote,
    required this.local,
    required this.network,
  });

  final LocationRemoteDataSource remote;
  final LocationLocalDataSource local;
  final NetworkInfo network;

  @override
  Future<void> sendPing(LocationPing ping) async {
    final model = LocationPingModel(
      latitude: ping.latitude,
      longitude: ping.longitude,
      accuracy: ping.accuracy,
      timestamp: ping.timestamp,
    );
    if (await network.isOnline) {
      try {
        await remote.ping(model);
        return;
      } catch (_) {
        // Fall through to buffering on failure.
      }
    }
    await local.buffer(model);
  }

  @override
  Future<void> drainBuffer() async {
    if (local.isEmpty || !(await network.isOnline)) return;
    final pings = local.drain();
    await remote.syncBatch(pings);
    await local.clear();
  }

  @override
  Future<List<LocationPing>> nearby({
    required double lat,
    required double lng,
    required double radiusMeters,
  }) =>
      remote.nearby(lat: lat, lng: lng, radiusMeters: radiusMeters);
}
