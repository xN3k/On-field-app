import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import '../../features/tasks/domain/entities/task.dart';
import 'avatar_chip.dart';
import 'status_badge.dart';

/// Task list card: left status stripe, title, meta row, status badge.
class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    this.assigneeName,
    this.onTap,
    super.key,
  });

  final Task task;
  final String? assigneeName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final stripe = StatusBadge.color(context, task.status);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: stripe),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: text.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(task.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (assigneeName != null) ...[
                            AvatarChip(name: assigneeName, radius: 10),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                assigneeName!,
                                style: text.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (task.createdAt != null) ...[
                            Icon(
                              Icons.event,
                              size: 14,
                              color: context.colors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat.MMMd().format(task.createdAt!),
                              style: text.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                      if (task.hasGeofence) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${task.geofenceLat!.toStringAsFixed(4)}, '
                              '${task.geofenceLng!.toStringAsFixed(4)}',
                              style: text.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Icon(
                    Icons.chevron_right,
                    color: context.colors.outlineVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
