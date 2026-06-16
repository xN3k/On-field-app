import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../widgets/change_password_sheet.dart';

String _themeLabel(ThemeMode mode) => switch (mode) {
      ThemeMode.system => 'System default',
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
    };

/// Profile / account screen for all roles.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value?.user;
    final notificationsOn = ref.watch(notificationsEnabledProvider);
    final themeMode = ref.watch(appThemeModeProvider);

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
                  background: context.colors.infoContainer,
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
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: const Text('Theme'),
                  trailing: Text(
                    _themeLabel(themeMode),
                    style: TextStyle(color: context.colors.onSurfaceVariant),
                  ),
                  onTap: () => _showThemeSheet(context, ref, themeMode),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Device', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone_iphone),
              title: const Text('Push notifications'),
              trailing: Text('In-app only',
                  style: TextStyle(color: context.colors.onSurfaceVariant)),
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

  void _showThemeSheet(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) {
    showAppSheet<void>(
      context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: RadioGroup<ThemeMode>(
          groupValue: current,
          onChanged: (selected) {
            if (selected != null) {
              ref.read(appThemeModeProvider.notifier).set(selected);
            }
            Navigator.pop(sheetContext);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final mode in ThemeMode.values)
                RadioListTile<ThemeMode>(
                  value: mode,
                  title: Text(_themeLabel(mode)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
