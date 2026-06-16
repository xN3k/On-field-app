import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';

/// One entry in the role-specific tab bar, pointing at a shell branch index.
class _NavTab {
  const _NavTab(this.branch, this.icon, this.label);
  final int branch;
  final IconData icon;
  final String label;
}

/// Branch order must match the StatefulShellRoute branch list in app_router.
abstract final class NavBranches {
  static const home = 0;
  static const dashboard = 1;
  static const tasks = 2;
  static const map = 3;
  static const reports = 4;
  static const sync = 5;
  static const team = 6;
  static const profile = 7;
}

const _workerTabs = [
  _NavTab(NavBranches.home, Icons.home_outlined, 'Home'),
  _NavTab(NavBranches.tasks, Icons.assignment_outlined, 'Tasks'),
  _NavTab(NavBranches.reports, Icons.assessment_outlined, 'Reports'),
  _NavTab(NavBranches.sync, Icons.sync, 'Sync'),
  _NavTab(NavBranches.profile, Icons.person_outline, 'Profile'),
];

const _managerTabs = [
  _NavTab(NavBranches.dashboard, Icons.dashboard_outlined, 'Dashboard'),
  _NavTab(NavBranches.tasks, Icons.assignment_outlined, 'Tasks'),
  _NavTab(NavBranches.map, Icons.map_outlined, 'Map'),
  _NavTab(NavBranches.reports, Icons.assessment_outlined, 'Reports'),
  _NavTab(NavBranches.team, Icons.groups_outlined, 'Team'),
];

/// Role-aware scaffold around the StatefulShellRoute: renders only the
/// current role's five tabs over the shared branch set.
class OnFieldNavShell extends ConsumerWidget {
  const OnFieldNavShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value?.user;
    final tabs = (user?.role.isManager ?? false) ? _managerTabs : _workerTabs;

    return Scaffold(
      body: shell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          border: Border(top: BorderSide(color: context.colors.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                for (final tab in tabs) _item(context, tab),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, _NavTab tab) {
    final selected = shell.currentIndex == tab.branch;
    return Expanded(
      child: InkWell(
        onTap: () => shell.goBranch(
          tab.branch,
          initialLocation: tab.branch == shell.currentIndex,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.base),
              ),
              child: Icon(
                tab.icon,
                size: 24,
                color: selected ? Colors.white : context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color:
                    selected ? AppColors.primary : context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
