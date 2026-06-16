/// App-wide tunables.
class AppConstants {
  AppConstants._();

  /// How often the background service emits a location ping.
  static const Duration locationPingInterval = Duration(minutes: 15);

  /// Default geofence radius (meters) when a task omits one.
  static const int defaultGeofenceRadius = 100;

  static const String backgroundLocationTask = 'onfield.locationPing';
}
