import '../entities/location_ping.dart';

abstract class LocationRepository {
  /// Sends a ping when online, otherwise buffers it locally for later sync.
  Future<void> sendPing(LocationPing ping);

  /// Drains buffered pings to the server (called on reconnect).
  /// Returns the sync batch id when a batch was submitted.
  Future<String?> drainBuffer();

  /// Latest position per worker within [radiusMeters] of a point (managers).
  Future<List<LocationPing>> nearby({
    required double lat,
    required double lng,
    required double radiusMeters,
  });

  /// Paged ping history for a worker (managers may pass any userId).
  Future<List<LocationPing>> history({
    String? userId,
    DateTime? from,
    DateTime? to,
    int page,
    int limit,
  });

  /// Most recent position for a worker (managers).
  Future<LocationPing?> latest(String userId);
}
