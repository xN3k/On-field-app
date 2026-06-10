import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';

/// Builds the shared Dio instance with the auth interceptor installed.
Dio buildDio({
  required SecureStorage storage,
  required Future<void> Function() onRefreshFailed,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(storage: storage, onRefreshFailed: onRefreshFailed),
  );

  // Log all traffic to the debug console (debug builds only).
  if (kDebugMode) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('➡️ ${options.method} ${options.uri}');
          if (options.data != null) debugPrint('   body: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
              '✅ ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (err, handler) {
          debugPrint(
              '❌ ${err.requestOptions.method} ${err.requestOptions.uri}');
          debugPrint('   type: ${err.type}');
          debugPrint('   status: ${err.response?.statusCode}');
          debugPrint('   message: ${err.message}');
          if (err.response?.data != null) {
            debugPrint('   data: ${err.response?.data}');
          }
          handler.next(err);
        },
      ),
    );
  }
  return dio;
}

/// Unwraps the `{ success, data, meta }` envelope, returning `data`.
T unwrap<T>(Response<dynamic> response) {
  final body = response.data;
  if (body is Map<String, dynamic> && body.containsKey('data')) {
    return body['data'] as T;
  }
  return body as T;
}
