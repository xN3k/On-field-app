import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../../features/reports/domain/entities/report.dart';
import '../../features/tasks/domain/entities/task.dart';

/// Non-interactive, pill-shaped task status indicator.
class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key});

  final TaskStatus status;

  /// Stripe / accent color associated with a task status.
  static Color color(BuildContext context, TaskStatus status) =>
      switch (status) {
        TaskStatus.pending => context.colors.pendingGray,
        TaskStatus.inProgress => AppColors.warning,
        TaskStatus.completed => AppColors.success,
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      TaskStatus.pending => (
          context.colors.surfaceContainerHigh,
          context.colors.onSurfaceVariant,
        ),
      TaskStatus.inProgress => (context.colors.warningContainer, AppColors.warning),
      TaskStatus.completed => (
          context.colors.successContainer,
          context.colors.onSuccessContainer,
        ),
    };
    return Pill(label: status.label, background: bg, foreground: fg);
  }
}

/// Pill-shaped report sync status indicator.
class SyncStatusBadge extends StatelessWidget {
  const SyncStatusBadge(this.status, {super.key});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, icon, bg, fg) = switch (status) {
      SyncStatus.synced => (
          'Synced',
          Icons.check_circle_outline,
          context.colors.successContainer,
          context.colors.onSuccessContainer,
        ),
      SyncStatus.pending => (
          'Pending',
          Icons.schedule,
          context.colors.warningContainer,
          AppColors.warning,
        ),
      SyncStatus.failed => (
          'Failed',
          Icons.error_outline,
          context.colors.errorContainer,
          context.colors.onErrorContainer,
        ),
    };
    return Pill(label: label, icon: icon, background: bg, foreground: fg);
  }
}

/// Generic pill used for statuses, roles and priorities.
class Pill extends StatelessWidget {
  const Pill({
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
    super.key,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
