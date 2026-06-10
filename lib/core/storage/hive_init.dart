import 'package:hive_ce_flutter/hive_flutter.dart';

import '../constants/hive_constants.dart';

/// Initializes Hive and opens all boxes. Values are stored as JSON-encoded
/// strings (see the *LocalDataSource classes), so no type adapters are needed.
class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<String>(HiveConstants.userBox),
      Hive.openBox<String>(HiveConstants.tasksBox),
      Hive.openBox<String>(HiveConstants.reportsBox),
      Hive.openBox<String>(HiveConstants.locationBox),
      Hive.openBox<String>(HiveConstants.syncMetaBox),
      Hive.openBox<String>(HiveConstants.notificationsBox),
    ]);
  }

  static Box<String> box(String name) => Hive.box<String>(name);
}
