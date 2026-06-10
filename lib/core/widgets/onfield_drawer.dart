import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../router/routes.dart';
import '../theme/app_theme.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';

/// App navigation drawer (menu) with profile header, nav items and footer.
class OnFieldDrawer extends ConsumerWidget {
  const OnFieldDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value?.user;
    final isManager = user?.role.isManager ?? false;
    final route = GoRouterState.of(context).matchedLocation;

    return Drawer(
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(user: user),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? user?.email ?? 'Worker',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_roleLabel(user?.role)} Role',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 12),

            // Nav items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  if (isManager)
                    _item(
                      context,
                      icon: Icons.dashboard_outlined,
                      label: 'Dashboard',
                      selected: route == Routes.dashboard,
                      onTap: () => _go(context, Routes.dashboard),
                    ),
                  _item(
                    context,
                    icon: Icons.assignment_outlined,
                    label: 'Tasks',
                    selected: route == Routes.tasks,
                    onTap: () => _go(context, Routes.tasks),
                  ),
                  _item(
                    context,
                    icon: Icons.groups_outlined,
                    label: isManager ? 'Team Status' : 'Map',
                    selected: route == Routes.map,
                    onTap: () => _go(context, Routes.map),
                  ),
                  _item(
                    context,
                    icon: Icons.inventory_2_outlined,
                    label: 'Inventory',
                    onTap: () => _comingSoon(context, 'Inventory'),
                  ),
                  _item(
                    context,
                    icon: Icons.bar_chart_outlined,
                    label: 'Analytics',
                    onTap: () => _comingSoon(context, 'Analytics'),
                  ),
                  _item(
                    context,
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () => _comingSoon(context, 'Settings'),
                  ),
                ],
              ),
            ),

            // Footer
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ONFIELD',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'V1.0.0-Stable',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Logout',
                    icon: const Icon(Icons.logout,
                        color: AppColors.onSurface),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ref.read(authControllerProvider.notifier).logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.go(route);
  }

  void _comingSoon(BuildContext context, String feature) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon')),
    );
  }

  String _roleLabel(Role? role) => switch (role) {
        Role.admin => 'Admin',
        Role.manager => 'Manager',
        _ => 'Worker',
      };

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? AppColors.infoContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon,
                    size: 24,
                    color: selected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? AppColors.primary
                        : AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? user?.email ?? '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    final initials = parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();

    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.infoContainer,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        // Online indicator
        Positioned(
          right: 2,
          bottom: 2,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 2.5),
            ),
          ),
        ),
      ],
    );
  }
}
