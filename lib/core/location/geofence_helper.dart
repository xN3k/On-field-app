import 'dart:math' as math;

/// Geofence math (used client-side for instant feedback; the server is the
/// source of truth via PostGIS).
class GeofenceHelper {
  GeofenceHelper._();

  static const double _earthRadiusMeters = 6371000;

  /// Great-circle distance between two points in meters (haversine).
  static double distanceMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return _earthRadiusMeters * c;
  }

  static bool isInside(
    double lat,
    double lng,
    double centerLat,
    double centerLng,
    int radiusMeters,
  ) =>
      distanceMeters(lat, lng, centerLat, centerLng) <= radiusMeters;

  static double _toRad(double deg) => deg * math.pi / 180;
}
