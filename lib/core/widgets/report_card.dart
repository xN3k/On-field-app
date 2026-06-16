import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import '../../features/reports/domain/entities/report.dart';
import 'status_badge.dart';

/// Report list card: notes preview, timestamp, sync status badge.
class ReportCard extends StatelessWidget {
  const ReportCard({
    required this.report,
    this.taskTitle,
    this.workerName,
    this.onTap,
    super.key,
  });

  final Report report;
  final String? taskTitle;
  final String? workerName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final notes = report.payload['notes']?.toString() ?? '';
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      taskTitle ?? 'Report',
                      style: text.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SyncStatusBadge(report.syncStatus),
                ],
              ),
              if (notes.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  notes,
                  style: text.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (workerName != null) ...[
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(workerName!, style: text.bodyMedium),
                    const SizedBox(width: 12),
                  ],
                  if (report.createdAt != null) ...[
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat.yMMMd().add_jm().format(report.createdAt!),
                      style: text.bodyMedium,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
