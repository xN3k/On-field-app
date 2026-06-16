import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Location-permission flow designed to satisfy Google Play & Apple App Store
/// policy: an in-app rationale is shown *before* the OS prompt, foreground
/// ("while in use") access is requested first, and background access is only
/// requested behind a separate, prominent disclosure after foreground is
/// granted and the user has opted into continuous tracking.
class LocationPermissionService {
  const LocationPermissionService._();

  /// Ensures foreground (while-in-use) location is usable. Returns true when
  /// the app may read the device position. Safe to call repeatedly — it no-ops
  /// once permission is already granted.
  static Future<bool> ensureForeground(BuildContext context) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (context.mounted) {
        final open = await _ask(
          context,
          'Location is off',
          'Turn on location services to see the map and track field work.',
          confirmLabel: 'Open settings',
        );
        if (open == true) await Geolocator.openLocationSettings();
      }
      return false;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      // Rationale before the system prompt (policy-friendly).
      if (!context.mounted) return false;
      final go = await _ask(
        context,
        'Allow location access',
        'OnField uses your location to show your position on the map and to '
            'verify you are inside a task’s geofence. You can change this '
            'anytime in Settings.',
      );
      if (go != true) return false;
      perm = await Geolocator.requestPermission();
    }

    if (perm == LocationPermission.deniedForever) {
      if (context.mounted) {
        final open = await _ask(
          context,
          'Location permission needed',
          'Location access is turned off for OnField. Open settings to enable '
              'it.',
          confirmLabel: 'Open settings',
        );
        if (open == true) await Geolocator.openAppSettings();
      }
      return false;
    }

    return perm == LocationPermission.always ||
        perm == LocationPermission.whileInUse;
  }

  /// Requests background ("always") location behind a prominent disclosure, as
  /// required by Google Play & Apple policy. Call only when the user has opted
  /// into continuous shift tracking. Foreground access is ensured first.
  static Future<bool> ensureBackground(BuildContext context) async {
    if (!await ensureForeground(context)) return false;

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.always) return true;

    if (!context.mounted) return false;
    final go = await _ask(
      context,
      'Allow background location',
      'To keep your team updated while you work, OnField needs to access your '
          'location in the background — even when the app is closed or not in '
          'use. Your location is only shared with your managers during active '
          'shifts.',
      confirmLabel: 'Continue',
    );
    if (go != true) return false;

    perm = await Geolocator.requestPermission();
    return perm == LocationPermission.always;
  }

  static Future<bool?> _ask(
    BuildContext context,
    String title,
    String body, {
    String confirmLabel = 'Continue',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}
