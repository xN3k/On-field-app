class Routes {
  Routes._();

  // Top-level (no shell)
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  // Shell branches
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String tasks = '/tasks';
  static const String map = '/map';
  static const String reports = '/reports';
  static const String sync = '/sync';
  static const String team = '/team';
  static const String profile = '/profile';

  // Pushed details (root navigator)
  static const String taskCreate = '/tasks/new';
  static const String taskDetail = '/tasks/:id';
  static const String taskEdit = '/tasks/:id/edit';
  static const String taskReassign = '/tasks/:id/reassign';
  static const String reportForm = '/tasks/:id/report';
  static const String reportDetail = '/reports/:id';
  static const String workerProfile = '/team/:userId';
  static const String locationHistory = '/team/:userId/history';
  static const String notifications = '/notifications';
  static const String adminSettings = '/settings/admin';

  static String taskDetailPath(String id) => '/tasks/$id';
  static String taskEditPath(String id) => '/tasks/$id/edit';
  static String taskReassignPath(String id) => '/tasks/$id/reassign';
  static String reportFormPath(String id) => '/tasks/$id/report';
  static String reportDetailPath(String id) => '/reports/$id';
  static String workerProfilePath(String userId) => '/team/$userId';
  static String locationHistoryPath(String userId) => '/team/$userId/history';
}
