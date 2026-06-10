import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/manager_dashboard_screen.dart';
import '../../features/location/presentation/screens/map_screen.dart';
import '../../features/reports/presentation/screens/report_form_screen.dart';
import '../../features/tasks/presentation/screens/task_detail_screen.dart';
import '../../features/tasks/presentation/screens/task_list_screen.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// Notifies GoRouter to re-run redirects whenever auth state changes.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = _AuthRefresh(ref);

  return GoRouter(
    initialLocation: Routes.tasks,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      // While resolving the session, don't redirect.
      if (auth.isLoading || !auth.hasValue) return null;

      final authed = auth.value!.isAuthenticated;
      final loggingIn = state.matchedLocation == Routes.login;

      if (!authed) return loggingIn ? null : Routes.login;
      if (loggingIn) return Routes.tasks;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.tasks,
        builder: (_, _) => const TaskListScreen(),
      ),
      GoRoute(
        path: Routes.taskDetail,
        builder: (_, s) => TaskDetailScreen(taskId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.reportForm,
        builder: (_, s) => ReportFormScreen(taskId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.map,
        builder: (_, _) => const MapScreen(),
      ),
      GoRoute(
        path: Routes.dashboard,
        builder: (_, _) => const ManagerDashboardScreen(),
      ),
    ],
  );
}
