import 'dart:async';

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

/// Attaches the bearer token and transparently refreshes it on a 401,
/// retrying the original request. Concurrent 401s share a single refresh
/// (single-flight) to avoid a refresh stampede.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.storage,
    required this.onRefreshFailed,
  });

  final SecureStorage storage;
  final Future<void> Function() onRefreshFailed;

  /// Bare Dio (no interceptors) used solely to call the refresh endpoint.
  final Dio _refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<String?>? _ongoingRefresh;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] != true) {
      final token = await storage.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;

    if (!isUnauthorized || alreadyRetried) {
      return handler.next(err);
    }

    final newToken = await _refreshToken();
    if (newToken == null) {
      await onRefreshFailed();
      return handler.next(err);
    }

    // Retry the original request once with the refreshed token.
    final options = err.requestOptions
      ..extra['retried'] = true
      ..headers['Authorization'] = 'Bearer $newToken';
    try {
      final response = await _refreshDio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Single-flight refresh: the first caller performs the network call; others
  /// await the same future.
  Future<String?> _refreshToken() {
    return _ongoingRefresh ??= _doRefresh().whenComplete(() {
      _ongoingRefresh = null;
    });
  }

  Future<String?> _doRefresh() async {
    final refreshToken = await storage.readRefreshToken();
    if (refreshToken == null) return null;
    try {
      final res = await _refreshDio.post<Map<String, dynamic>>(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null) return null;
      final access = data['accessToken'] as String;
      final refresh = data['refreshToken'] as String;
      await storage.saveTokens(accessToken: access, refreshToken: refresh);
      return access;
    } on DioException {
      await storage.clear();
      return null;
    }
  }
}
