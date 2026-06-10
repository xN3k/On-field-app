import 'dart:io' show Platform;

/// Network endpoints and base URL. Override the base URL at run time with
/// --dart-define=API_BASE_URL=... When unset, the host that reaches the dev
/// machine differs per platform: Android emulator uses 10.0.2.2, while the
/// iOS simulator (and desktop) reach the host via localhost.
class ApiConstants {
  ApiConstants._();

  static const String _override =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static final String baseUrl = _override.isNotEmpty
      ? _override
      : (Platform.isAndroid
          ? 'http://10.0.2.2:3000'
          : 'http://localhost:3000');

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Tasks
  static const String tasks = '/tasks';
  static String taskById(String id) => '/tasks/$id';
  static String taskStatus(String id) => '/tasks/$id/status';

  // Location
  static const String location = '/location';
  static const String locationNearby = '/location/nearby';

  // Reports
  static const String reports = '/reports';

  // Sync
  static const String syncBatch = '/sync/batch';
}
