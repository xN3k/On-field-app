import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/app_theme.dart';

/// OpenStreetMap raster tiles. OSM's tile usage policy requires a descriptive
/// User-Agent and visible attribution — see [osmAttribution], which every map
/// that renders these tiles must also include.
TileLayer osmTileLayer() => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.onfield.app',
      maxZoom: 19,
    );

/// Visible attribution required by the OSM tile usage policy. Add as the last
/// child of a [FlutterMap].
Widget osmAttribution() => const SimpleAttributionWidget(
      source: Text('© OpenStreetMap'),
    );

/// Semi-transparent cobalt fill with a solid border for a geofence zone.
/// flutter_map's [CircleMarker] draws the border itself, so the previous
/// dashed-polyline approximation is no longer needed.
CircleMarker geofenceCircle({
  required LatLng center,
  required double radiusMeters,
}) {
  return CircleMarker(
    point: center,
    radius: radiusMeters,
    useRadiusInMeter: true,
    color: AppColors.primary.withValues(alpha: 0.12),
    borderColor: AppColors.primary,
    borderStrokeWidth: 2,
  );
}
