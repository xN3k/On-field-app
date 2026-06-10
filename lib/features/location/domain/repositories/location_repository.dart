import '../entities/location_ping.dart';

abstract class LocationRepository {
  /// Sends a ping when online, otherwise buffers it locally for later sync.
  Future<void> sendPing(LocationPing ping);

  /// Drains buffered pings to the server (called on reconnect).
  Future<void> drainBuffer();

  /// Latest position per worker within [radiusMeters] of a point (managers).
  Future<List<LocationPing>> nearby({
    required double lat,
    required double lng,
    required double radiusMeters,
  });
}
