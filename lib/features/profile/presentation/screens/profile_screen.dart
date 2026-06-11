import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../widgets/change_password_sheet.dart';

/// Profile / account screen for all roles.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value?.user;
    final notificationsOn = ref.watch(notificationsEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                AvatarChip(name: user?.name ?? user?.email, radius: 40),
                const SizedBox(height: 12),
                Text(user?.name ?? '—',
                    style: Theme.of(context).textTheme.titleLarge),
                Text(user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Pill(
                  label: user?.role.wire ?? 'WORKER',
                  background: AppColors.infoContainer,
                  foreground: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Account', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showChangePasswordSheet(context),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Notifications'),
                  value: notificationsOn,
                  onChanged: (v) => ref
                      .read(notificationsEnabledProvider.notifier)
                      .toggle(v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Device', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.phone_iphone),
              title: Text('Push notifications'),
              trailing: Text('In-app only',
                  style: TextStyle(color: AppColors.onSurfaceVariant)),
            ),
          ),
          if (user?.role == Role.admin) ...[
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.settings_outlined, color: AppColors.primary),
                title: const Text('Admin Panel'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(Routes.adminSettings),
              ),
            ),
          ],
          const SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            onPressed: () =>
                ref.read(authControllerProvider.notifier).logout(),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('OnField v1.0.0',
                style: Theme.of(context).textTheme.labelSmall),
          ),
        ],
      ),
    );
  }
}
