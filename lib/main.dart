import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/location/background_location_service.dart';
import 'core/storage/hive_init.dart';

Future<void> main() async {
  // socket_io_client v3 can throw an async WebSocketConnectionClosed from
  // inside its own disconnect path when the server closes the connection.
  // It's harmless (the socket is already gone) — swallow it instead of
  // crashing; rethrow everything else.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await HiveInit.init();
    await BackgroundLocationService.initialize();
    runApp(const ProviderScope(child: OnFieldApp()));
  }, (error, stack) {
    if (error.toString().contains('WebSocketConnectionClosed')) {
      debugPrint('Ignored stale socket close: $error');
      return;
    }
    FlutterError.reportError(
      FlutterErrorDetails(exception: error, stack: stack),
    );
  });
}
