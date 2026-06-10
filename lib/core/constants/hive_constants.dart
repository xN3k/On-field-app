/// Hive box names and type ids. Type ids must be unique and stable.
class HiveConstants {
  HiveConstants._();

  // Boxes
  static const String userBox = 'user_box';
  static const String tasksBox = 'tasks_box';
  static const String reportsBox = 'reports_box';
  static const String locationBox = 'location_box';
  static const String syncMetaBox = 'sync_meta_box';
  static const String notificationsBox = 'notifications_box';

  // Type ids
  static const int userTypeId = 0;
  static const int taskTypeId = 1;
  static const int reportTypeId = 2;
  static const int locationTypeId = 3;
  static const int taskStatusTypeId = 4;
  static const int syncStatusTypeId = 5;
  static const int roleTypeId = 6;
}
