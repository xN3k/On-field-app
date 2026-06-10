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
  Future<void> syncBatch(List<LocationPingModel> pings) async {
    await _dio.post<dynamic>(
      ApiConstants.syncBatch,
      data: {'locations': pings.map((p) => p.toRequestJson()).toList()},
    );
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
