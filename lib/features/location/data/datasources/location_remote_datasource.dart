import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/location_ping_model.dart';

class LocationRemoteDataSource {
  LocationRemoteDataSource(this._dio);

  final Dio _dio;

  Future<void> ping(LocationPingModel ping) async {
    await _dio.post<dynamic>(ApiConstants.location, data: ping.toRequestJson());
  }

  /// Sends a buffered batch via the offline sync endpoint.
  /// Returns the server-assigned batch id (for status tracking).
  Future<String?> syncBatch(List<LocationPingModel> pings) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiConstants.syncBatch,
      data: {'locations': pings.map((p) => p.toRequestJson()).toList()},
    );
    final data = unwrap<dynamic>(res);
    return data is Map<String, dynamic> ? data['batchId'] as String? : null;
  }

  /// Paged history of a worker's pings (managers may pass any userId).
  Future<List<LocationPingModel>> history({
    String? userId,
    DateTime? from,
    DateTime? to,
    int page = 1,
    int limit = 50,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiConstants.locationHistory,
      queryParameters: {
        'userId': ?userId,
        'from': ?from?.toIso8601String(),
        'to': ?to?.toIso8601String(),
        'page': page,
        'limit': limit,
      },
    );
    final data = unwrap<List<dynamic>>(res);
    return data
        .map((e) => LocationPingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<LocationPingModel?> latest(String userId) async {
    final res = await _dio
        .get<Map<String, dynamic>>(ApiConstants.locationLatest(userId));
    final data = unwrap<dynamic>(res);
    if (data == null) return null;
    return LocationPingModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<LocationPingModel>> nearby({
    required double lat,
    required double lng,
    required double radiusMeters,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiConstants.locationNearby,
      queryParameters: {'lat': lat, 'lng': lng, 'radius': radiusMeters},
    );
    final data = unwrap<List<dynamic>>(res);
    return data
        .map((e) => LocationPingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
