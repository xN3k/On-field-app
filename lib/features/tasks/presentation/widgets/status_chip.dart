import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/task.dart';

/// Non-interactive, pill-shaped status indicator (DESIGN.md → Status Chips).
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      TaskStatus.pending => (
          AppColors.surfaceContainerHigh,
          AppColors.onSurfaceVariant,
        ),
      TaskStatus.inProgress => (AppColors.infoContainer, AppColors.primary),
      TaskStatus.completed => (
          AppColors.successContainer,
          AppColors.onSuccessContainer,
        ),
    };
    return Pill(label: status.label, background: bg, foreground: fg);
  }
}

/// Generic pill used for statuses and priorities.
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
