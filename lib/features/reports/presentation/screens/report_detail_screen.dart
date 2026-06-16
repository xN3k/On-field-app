import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../tasks/presentation/providers/task_list_provider.dart';
import '../../../users/presentation/providers/user_providers.dart';
import '../providers/report_providers.dart';

class ReportDetailScreen extends ConsumerWidget {
  const ReportDetailScreen({required this.reportId, super.key});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(reportDetailProvider(reportId));

    return Scaffold(
      appBar: AppBar(title: const Text('Report')),
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load report: $e')),
        data: (report) {
          if (report == null) {
            return const EmptyState(
              icon: Icons.assessment_outlined,
              title: 'Report not found',
            );
          }
          final task = report.taskId.isNotEmpty
              ? ref.watch(taskDetailProvider(report.taskId)).value
              : null;
          final directory = ref.watch(userDirectoryProvider).value;
          final worker =
              directory == null ? null : directory[report.userId];
          final notes = report.payload['notes']?.toString();
          final extras = Map<String, dynamic>.from(report.payload)
            ..remove('notes');

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          context.push(Routes.taskDetailPath(report.taskId)),
                      child: Text(
                        task?.title ?? 'View linked task',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  SyncStatusBadge(report.syncStatus),
                ],
              ),
              if (report.createdAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Submitted ${DateFormat.yMMMd().add_jm().format(report.createdAt!)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              if (worker != null)
                Card(
                  child: ListTile(
                    leading: AvatarChip(name: worker.name ?? worker.email),
                    title: Text(worker.name ?? worker.email),
                    subtitle: Text(worker.email),
                  ),
                ),
              const SizedBox(height: 16),
              if (notes != null && notes.isNotEmpty) ...[
                Text('Notes', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(notes,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(height: 1.6)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (extras.isNotEmpty) ...[
                Text('Custom Fields',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      for (final entry in extras.entries)
                        ListTile(
                          dense: true,
                          title: Text(entry.key),
                          trailing: Text(
                            '${entry.value}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.colors.onSurface),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
