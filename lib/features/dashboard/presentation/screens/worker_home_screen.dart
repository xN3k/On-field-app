import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/task_card.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../reports/presentation/providers/report_providers.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_list_provider.dart';

/// Worker home dashboard: greeting, summary cards, active task list.
class WorkerHomeScreen extends ConsumerWidget {
  const WorkerHomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value?.user;
    final tasksAsync = ref.watch(taskListProvider);
    final pendingSync = ref.watch(pendingReportCountProvider);
    final unread = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${_greeting()}, ${user?.name?.split(' ').first ?? ''}'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => context.push(Routes.notifications),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AvatarChip(name: user?.name ?? user?.email, radius: 16),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(taskListProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'My Tasks Today',
                          value:
                              '${(tasksAsync.value ?? []).where((t) => t.status != TaskStatus.completed).length}',
                          icon: Icons.assignment_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Pending Sync',
                          value: '$pendingSync',
                          icon: Icons.sync,
                          color: pendingSync > 0
                              ? Colors.orange.shade800
                              : Colors.green.shade700,
                          onTap: () => GoRouter.of(context).go(Routes.sync),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(
                    'Active Tasks',
                    actionLabel: 'View all',
                    onAction: () => GoRouter.of(context).go(Routes.tasks),
                  ),
                  ...tasksAsync.when(
                    loading: () => const [SkeletonCard(), SkeletonCard()],
                    error: (e, _) =>
                        [Center(child: Text('Failed to load tasks: $e'))],
                    data: (tasks) {
                      final active = tasks
                          .where((t) => t.status != TaskStatus.completed)
                          .toList();
                      if (active.isEmpty) {
                        return const [
                          EmptyState(
                            icon: Icons.assignment_outlined,
                            title: 'No tasks assigned yet',
                            subtitle:
                                'Your manager will assign tasks here.',
                          ),
                        ];
                      }
                      return [
                        for (final t in active) ...[
                          TaskCard(
                            task: t,
                            onTap: () =>
                                context.push(Routes.taskDetailPath(t.id)),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
