import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../theme/app_theme.dart';

/// Semi-transparent cobalt fill for a geofence zone.
Circle geofenceCircle({
  required String id,
  required LatLng center,
  required double radiusMeters,
}) {
  return Circle(
    circleId: CircleId(id),
    center: center,
    radius: radiusMeters,
    fillColor: AppColors.primary.withValues(alpha: 0.12),
    strokeWidth: 0,
  );
}

/// Dashed cobalt outline approximating the geofence circle.
/// google_maps Circle has no dash pattern, so we draw a segmented polyline.
Polyline geofenceOutline({
  required String id,
  required LatLng center,
  required double radiusMeters,
  int segments = 60,
}) {
  const earthRadius = 6371000.0;
  final latRad = center.latitude * math.pi / 180;
  final dLat = (radiusMeters / earthRadius) * 180 / math.pi;
  final dLng = dLat / math.cos(latRad);

  final points = List<LatLng>.generate(segments + 1, (i) {
    final theta = 2 * math.pi * i / segments;
    return LatLng(
      center.latitude + dLat * math.sin(theta),
      center.longitude + dLng * math.cos(theta),
    );
  });

  return Polyline(
    polylineId: PolylineId(id),
    points: points,
    color: AppColors.primary,
    width: 2,
    patterns: [PatternItem.dash(16), PatternItem.gap(10)],
  );
}
