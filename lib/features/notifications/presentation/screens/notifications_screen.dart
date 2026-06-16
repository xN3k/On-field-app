import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/app_notification.dart';
import '../providers/notification_providers.dart';

/// Realtime geofence + task-status alerts, persisted locally.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(notificationsProvider);
    final local = ref.watch(notificationLocalDataSourceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: local.markAllRead,
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_outlined,
              title: 'No notifications yet',
              subtitle: 'Task and geofence alerts will appear here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) =>
                _NotificationTile(notification: items[i]),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (icon, accent) = switch (notification.type) {
      NotificationType.geofenceEnter =>
        (Icons.login, AppColors.success),
      NotificationType.geofenceExit => (Icons.logout, AppColors.error),
      NotificationType.taskStatus =>
        (Icons.assignment_outlined, AppColors.primary),
    };

    final title = notification.displayTitle;
    final body = notification.displayBody;

    return Material(
      color: notification.read
          ? context.colors.surfaceContainerLowest
          : AppColors.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () {
          ref
              .read(notificationLocalDataSourceProvider)
              .markRead(notification.id);
          final taskId = notification.taskId;
          if (taskId != null) {
            context.push(Routes.taskDetailPath(taskId));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border(
              left: BorderSide(color: accent, width: 4),
              top: BorderSide(color: context.colors.border),
              right: BorderSide(color: context.colors.border),
              bottom: BorderSide(color: context.colors.border),
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: context.colors.onSurface,
                      ),
                    ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        body,
                        style: TextStyle(
                          fontSize: 14,
                          color: context.colors.onSurface,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.yMMMd().add_jm().format(notification.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
