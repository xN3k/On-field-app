import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/location/background_location_service.dart';
import 'core/storage/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.init();
  await BackgroundLocationService.initialize();
  runApp(const ProviderScope(child: OnFieldApp()));
}
