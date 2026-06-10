import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<({String accessToken, String refreshToken, UserModel user})> login(
    String email,
    String password,
  ) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: {'email': email, 'password': password},
        options: Options(extra: {'skipAuth': true}),
      );
      final data = unwrap<Map<String, dynamic>>(res);
      return (
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
        user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('Invalid email or password');
      }
      throw ServerException(
        e.message ?? 'Login failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<UserModel> me() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiConstants.me);
    return UserModel.fromJson(unwrap<Map<String, dynamic>>(res));
  }
}
