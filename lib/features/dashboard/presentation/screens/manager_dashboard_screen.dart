import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/report_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../location/presentation/providers/location_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../reports/presentation/providers/report_providers.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_list_provider.dart';
import '../../../users/presentation/providers/user_providers.dart';

class ManagerDashboardScreen extends ConsumerWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider).value ?? const <Task>[];
    final team = ref.watch(teamLocationsProvider).value ?? const [];
    final unread = ref.watch(unreadNotificationCountProvider);
    final reports =
        ref.watch(reportsListProvider()).value ?? const [];
    final directory = ref.watch(userDirectoryProvider).value ?? const {};

    final pendingTasks =
        tasks.where((t) => t.status != TaskStatus.completed).length;
    final recentTasks = tasks.take(4).toList();
    final recentReports = reports.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('OnField'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => context.push(Routes.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => GoRouter.of(context).go(Routes.profile),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(taskListProvider.notifier).refresh();
          ref.invalidate(reportsListProvider());
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text('Overview', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text('Live operations status.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Active Workers',
                    value: '${team.length}',
                    icon: Icons.people_outline,
                    onTap: () => GoRouter.of(context).go(Routes.team),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Tasks Today',
                    value: '$pendingTasks',
                    icon: Icons.assignment_outlined,
                    color: AppColors.warning,
                    onTap: () => GoRouter.of(context).go(Routes.tasks),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Reports',
                    value: '${reports.length}',
                    icon: Icons.assessment_outlined,
                    color: AppColors.success,
                    onTap: () => GoRouter.of(context).go(Routes.reports),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => GoRouter.of(context).go(Routes.map),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map_outlined,
                          size: 36, color: AppColors.primary),
                      SizedBox(height: 8),
                      Text('View Full Map',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SectionHeader(
              'Recent Tasks',
              actionLabel: 'View all',
              onAction: () => GoRouter.of(context).go(Routes.tasks),
            ),
            for (final t in recentTasks) ...[
              Card(
                child: ListTile(
                  leading: AvatarChip(
                    name: directory[t.assignedToId]?.name ??
                        directory[t.assignedToId]?.email,
                    radius: 16,
                  ),
                  title: Text(t.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: StatusBadge(t.status),
                  onTap: () => context.push(Routes.taskDetailPath(t.id)),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (recentTasks.isEmpty)
              Text('No tasks yet.',
                  style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            SectionHeader(
              'Recent Reports',
              actionLabel: 'View all',
              onAction: () => GoRouter.of(context).go(Routes.reports),
            ),
            for (final r in recentReports) ...[
              ReportCard(
                report: r,
                workerName: directory[r.userId]?.name,
                onTap: r.id != null
                    ? () => context.push(Routes.reportDetailPath(r.id!))
                    : null,
              ),
              const SizedBox(height: 8),
            ],
            if (recentReports.isEmpty)
              Text('No reports yet.',
                  style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
