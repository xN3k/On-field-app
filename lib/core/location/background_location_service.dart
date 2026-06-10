import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';

/// Entry point for the WorkManager background isolate. Must be top-level and
/// annotated so it survives tree-shaking. Riverpod is NOT available here, so we
/// talk to secure storage / Dio directly.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != AppConstants.backgroundLocationTask) return true;
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      if (token == null) return true; // Not logged in.

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      await dio.post<dynamic>(
        ApiConstants.location,
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return true;
    } catch (_) {
      // Returning false asks WorkManager to retry with backoff.
      return false;
    }
  });
}

/// Foreground-facing controls for the background location task.
class BackgroundLocationService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> start() async {
    await Workmanager().registerPeriodicTask(
      AppConstants.backgroundLocationTask,
      AppConstants.backgroundLocationTask,
      frequency: AppConstants.locationPingInterval,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  static Future<void> stop() async {
    await Workmanager().cancelByUniqueName(AppConstants.backgroundLocationTask);
  }
}
