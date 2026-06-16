import 'package:dio/dio.dart';

/// A single forward-geocoding match from Nominatim.
class GeocodingResult {
  const GeocodingResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  final String displayName;
  final double latitude;
  final double longitude;
}

/// Forward geocoding (address → coordinates) via OpenStreetMap's Nominatim,
/// the same project that powers our flutter_map tiles. No API key required.
///
/// Nominatim's usage policy requires a descriptive User-Agent and at most one
/// request per second — fine for a search-on-submit field. A bare [Dio] is
/// used so the app's bearer token is never sent to a third party.
class GeocodingService {
  const GeocodingService._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://nominatim.openstreetmap.org',
      headers: {'User-Agent': 'OnField/1.0 (com.onfield.app)'},
    ),
  );

  static Future<List<GeocodingResult>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final resp = await _dio.get<List<dynamic>>(
      '/search',
      queryParameters: {'q': q, 'format': 'json', 'limit': 6},
    );
    final data = resp.data ?? const [];
    return [
      for (final item in data.cast<Map<String, dynamic>>())
        GeocodingResult(
          displayName: item['display_name'] as String? ?? '',
          latitude: double.parse(item['lat'] as String),
          longitude: double.parse(item['lon'] as String),
        ),
    ];
  }
}
