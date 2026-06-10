class Routes {
  Routes._();

  static const String login = '/login';
  static const String tasks = '/tasks';
  static const String taskDetail = '/tasks/:id';
  static const String map = '/map';
  static const String dashboard = '/dashboard';
  static const String reportForm = '/tasks/:id/report';

  static String taskDetailPath(String id) => '/tasks/$id';
  static String reportFormPath(String id) => '/tasks/$id/report';
}
