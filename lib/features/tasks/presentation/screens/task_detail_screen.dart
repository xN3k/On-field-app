import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/routes.dart';
import '../../domain/entities/task.dart';
import '../providers/task_list_provider.dart';
import '../widgets/status_chip.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (task) => _TaskBody(task: task),
      ),
      floatingActionButton: taskAsync.maybeWhen(
        data: (task) => FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.description_outlined),
          label: const Text('Add Report'),
          onPressed: () => context.push(Routes.reportFormPath(task.id)),
        ),
        orElse: () => null,
      ),
    );
  }
}

class _TaskBody extends ConsumerWidget {
  const _TaskBody({required this.task});

  final Task task;

  static const _nextStatus = {
    TaskStatus.pending: TaskStatus.inProgress,
    TaskStatus.inProgress: TaskStatus.completed,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = _nextStatus[task.status];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        _card(
          context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(task.title,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  StatusChip(task.status),
                ],
              ),
              if (task.description != null) ...[
                const SizedBox(height: 12),
                Text(task.description!,
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ],
          ),
        ),
        if (task.hasGeofence) ...[
          const SizedBox(height: 16),
          _card(
            context,
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.infoContainer,
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.my_location, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Geofence',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        '${task.geofenceLat!.toStringAsFixed(5)}, '
                        '${task.geofenceLng!.toStringAsFixed(5)}  •  '
                        '${task.geofenceRadius ?? 0} m',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        if (next != null)
          FilledButton.icon(
            icon: const Icon(Icons.arrow_forward),
            label: Text('Mark ${next.label}'),
            onPressed: () async {
              await ref
                  .read(taskListProvider.notifier)
                  .updateStatus(task.id, next);
              ref.invalidate(taskDetailProvider(task.id));
            },
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.successContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: AppColors.onSuccessContainer),
                SizedBox(width: 8),
                Text('Task completed',
                    style: TextStyle(
                        color: AppColors.onSuccessContainer,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _card(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
  }
}
