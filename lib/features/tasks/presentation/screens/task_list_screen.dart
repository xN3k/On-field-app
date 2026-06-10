import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/onfield_bottom_nav.dart';
import '../../../../core/widgets/onfield_drawer.dart';
import '../../../../core/router/routes.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../reports/presentation/providers/report_providers.dart';
import '../../domain/entities/task.dart';
import '../providers/task_list_provider.dart';
import '../widgets/status_chip.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String _query = '';
  TaskStatus? _filter; // null = All

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskListProvider);
    final user = ref.watch(authControllerProvider).value?.user;
    final isManager = user?.role.isManager ?? false;
    final pending = ref.watch(pendingReportCountProvider);

    return Scaffold(
      drawer: const OnFieldDrawer(),
      appBar: AppBar(
        title: const Text('OnField'),
        actions: [
          if (isManager)
            IconButton(
              tooltip: 'Dashboard',
              icon: const Icon(Icons.dashboard_outlined),
              onPressed: () => context.push(Routes.dashboard),
            ),
          IconButton(
            icon: Badge(
              isLabelVisible: pending > 0,
              label: Text('$pending'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () =>
                ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      bottomNavigationBar: const OnFieldBottomNav(current: OnFieldTab.tasks),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        onPressed: () => ref.read(taskListProvider.notifier).refresh(),
        child: const Icon(Icons.refresh),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _filterChip('All Tasks', null),
                _filterChip('Pending', TaskStatus.pending),
                _filterChip('In Progress', TaskStatus.inProgress),
                _filterChip('Completed', TaskStatus.completed),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(taskListProvider.notifier).refresh(),
              child: tasksAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => ListView(
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Text('Failed to load tasks:\n$e',
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
                data: (tasks) {
                  final filtered = tasks.where((t) {
                    final matchesFilter =
                        _filter == null || t.status == _filter;
                    final matchesQuery = _query.isEmpty ||
                        t.title.toLowerCase().contains(_query) ||
                        (t.description?.toLowerCase().contains(_query) ??
                            false);
                    return matchesFilter && matchesQuery;
                  }).toList();

                  if (filtered.isEmpty) {
                    return ListView(
                      children: const [
                        SizedBox(height: 120),
                        Center(child: Text('No tasks found.')),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (_, i) => _TaskCard(task: filtered[i]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, TaskStatus? status) {
    final selected = _filter == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => setState(() => _filter = status),
        backgroundColor: AppColors.surfaceContainerLowest,
        selectedColor: AppColors.primary,
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.outlineVariant,
        ),
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = switch (task.status) {
      TaskStatus.inProgress => AppColors.primary,
      TaskStatus.completed => AppColors.success,
      TaskStatus.pending => AppColors.outlineVariant,
    };

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 5, color: accent),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (task.createdAt != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 15, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          'Assigned: ${_fmtDate(task.createdAt!)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                  if (task.hasGeofence) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppRadius.base),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${task.geofenceLat!.toStringAsFixed(4)}, '
                              '${task.geofenceLng!.toStringAsFixed(4)} • '
                              '${task.geofenceRadius ?? 0}m',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StatusChip(task.status),
                      const Spacer(),
                      InkWell(
                        onTap: () =>
                            context.push(Routes.taskDetailPath(task.id)),
                        child: Row(
                          children: [
                            Text(
                              task.status == TaskStatus.pending
                                  ? 'Start Task'
                                  : 'View Details',
                              style: const TextStyle(
                                color: AppColors.primaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward,
                                size: 16, color: AppColors.primaryContainer),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  static String _fmtDate(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ampm = d.hour < 12 ? 'AM' : 'PM';
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.month}/${d.day} • $h:$m $ampm';
  }
}
