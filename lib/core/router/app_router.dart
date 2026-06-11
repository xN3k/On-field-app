import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/admin/presentation/screens/admin_settings_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/dashboard/presentation/screens/manager_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/worker_home_screen.dart';
import '../../features/location/presentation/screens/location_history_screen.dart';
import '../../features/location/presentation/screens/map_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/reports/presentation/screens/report_detail_screen.dart';
import '../../features/reports/presentation/screens/report_form_screen.dart';
import '../../features/reports/presentation/screens/reports_list_screen.dart';
import '../../features/sync/presentation/screens/sync_status_screen.dart';
import '../../features/tasks/presentation/screens/task_detail_screen.dart';
import '../../features/tasks/presentation/screens/task_form_screen.dart';
import '../../features/tasks/presentation/screens/task_list_screen.dart';
import '../../features/tasks/presentation/screens/task_reassign_screen.dart';
import '../../features/team/presentation/screens/team_screen.dart';
import '../../features/team/presentation/screens/worker_profile_screen.dart';
import '../widgets/onfield_nav_shell.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// Notifies GoRouter to re-run redirects whenever auth state changes.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Routes only managers/admins may visit; workers are bounced to /home.
const _managerOnlyPrefixes = [
  Routes.dashboard,
  Routes.map,
  Routes.team,
  Routes.taskCreate,
  Routes.register,
  '/settings',
];

bool _isManagerOnly(String location) =>
    _managerOnlyPrefixes.any(location.startsWith) ||
    location.endsWith('/edit') ||
    location.endsWith('/reassign');

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = _AuthRefresh(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;

      // While resolving the session, hold on the splash screen — but never
      // bounce the login screen to splash (a failed/in-flight login attempt
      // flips auth to loading; redirecting would flash the splash screen).
      if (auth.isLoading || !auth.hasValue) {
        if (location == Routes.login) return null;
        return location == Routes.splash ? null : Routes.splash;
      }

      final authState = auth.value!;
      final authed = authState.isAuthenticated;
      final atEntry = location == Routes.login || location == Routes.splash;

      if (!authed) return location == Routes.login ? null : Routes.login;

      final role = authState.user?.role ?? Role.worker;
      final roleHome = role.isManager ? Routes.dashboard : Routes.home;
      if (atEntry) return roleHome;
      if (!role.isManager && _isManagerOnly(location)) return Routes.home;
      if (location.startsWith('/settings') && role != Role.admin) {
        return roleHome;
      }
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => OnFieldNavShell(shell: shell),
        branches: [
          // Order must match NavBranches constants.
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.home,
              builder: (_, _) => const WorkerHomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.dashboard,
              builder: (_, _) => const ManagerDashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.tasks,
              builder: (_, _) => const TaskListScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.map,
              builder: (_, _) => const MapScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.reports,
              builder: (_, _) => const ReportsListScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.sync,
              builder: (_, _) => const SyncStatusScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.team,
              builder: (_, _) => const TeamScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.profile,
              builder: (_, _) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
      // Pushed details — root navigator, full screen without the tab bar.
      // taskCreate must precede taskDetail so '/tasks/new' wins over ':id'.
      GoRoute(
        path: Routes.taskCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const TaskFormScreen(),
      ),
      GoRoute(
        path: Routes.taskDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, s) => TaskDetailScreen(taskId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.taskEdit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, s) => TaskFormScreen(taskId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.taskReassign,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, s) =>
            TaskReassignScreen(taskId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.reportForm,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, s) => ReportFormScreen(taskId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.reportDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, s) =>
            ReportDetailScreen(reportId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.workerProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, s) =>
            WorkerProfileScreen(userId: s.pathParameters['userId']!),
      ),
      GoRoute(
        path: Routes.locationHistory,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, s) =>
            LocationHistoryScreen(userId: s.pathParameters['userId']!),
      ),
      GoRoute(
        path: Routes.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.register,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.adminSettings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const AdminSettingsScreen(),
      ),
    ],
  );
}
