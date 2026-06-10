import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/data/models/user_model.dart';

class UserRemoteDataSource {
  UserRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<UserModel>> getUsers({int page = 1, int limit = 100}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiConstants.users,
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = unwrap<List<dynamic>>(res);
    return data
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UserModel> getById(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(ApiConstants.userById(id));
    return UserModel.fromJson(unwrap<Map<String, dynamic>>(res));
  }

  Future<UserModel> updateUser(String id, Map<String, dynamic> patch) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      ApiConstants.userById(id),
      data: patch,
    );
    return UserModel.fromJson(unwrap<Map<String, dynamic>>(res));
  }

  Future<void> updateDeviceToken(String token) async {
    await _dio.patch<dynamic>(
      ApiConstants.deviceToken,
      data: {'deviceToken': token},
    );
  }
}
