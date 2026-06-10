/// Low-level exceptions thrown by data sources.
class ServerException implements Exception {
  ServerException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class CacheException implements Exception {
  CacheException(this.message);
  final String message;

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  NetworkException([this.message = 'No internet connection']);
  final String message;

  @override
  String toString() => message;
}
