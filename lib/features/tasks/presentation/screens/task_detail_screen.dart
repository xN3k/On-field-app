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
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (task) => _TaskBody(task: task),
      ),
      bottomNavigationBar: taskAsync.maybeWhen(
        data: (task) => _BottomAction(task: task),
        orElse: () => null,
      ),
    );
  }
}

class _BottomAction extends ConsumerWidget {
  const _BottomAction({required this.task});

  final Task task;

  static const _nextStatus = {
    TaskStatus.pending: TaskStatus.inProgress,
    TaskStatus.inProgress: TaskStatus.completed,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = _nextStatus[task.status];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: next == null
            ? OutlinedButton.icon(
                icon: const Icon(Icons.description_outlined),
                label: const Text('Add Report'),
                onPressed: () =>
                    context.push(Routes.reportFormPath(task.id)),
              )
            : FilledButton.icon(
                icon: Icon(next == TaskStatus.completed
                    ? Icons.check_circle_outline
                    : Icons.play_arrow),
                label: Text(next == TaskStatus.completed
                    ? 'Complete Task'
                    : 'Start Task'),
                onPressed: () async {
                  await ref
                      .read(taskListProvider.notifier)
                      .updateStatus(task.id, next);
                  ref.invalidate(taskDetailProvider(task.id));
                },
              ),
      ),
    );
  }
}

class _TaskBody extends ConsumerWidget {
  const _TaskBody({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        // Header card: title + priority/status pills.
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (task.description != null)
                    Expanded(
                      child: Text(
                        task.description!.split('\n').first,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  else
                    const Spacer(),
                  StatusChip(task.status),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Map / navigation block.
        if (task.hasGeofence) ...[
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFD6D6F2),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.radio_button_unchecked,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                  icon: const Icon(Icons.navigation_outlined, size: 18),
                  label: const Text('Start Navigation'),
                  onPressed: () => context.push(Routes.map),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Assigned / Distance info tiles.
        Row(
          children: [
            Expanded(
              child: _infoTile(
                context,
                icon: Icons.event_outlined,
                label: 'ASSIGNED',
                value: task.createdAt != null
                    ? _fmtDate(task.createdAt!)
                    : '—',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _infoTile(
                context,
                icon: Icons.route_outlined,
                label: 'RADIUS',
                value: task.geofenceRadius != null
                    ? '${task.geofenceRadius} m'
                    : '—',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (task.hasGeofence)
          _infoTile(
            context,
            icon: Icons.location_on_outlined,
            label: 'LOCATION',
            value: '${task.geofenceLat!.toStringAsFixed(5)}, '
                '${task.geofenceLng!.toStringAsFixed(5)}',
          ),
        const SizedBox(height: 16),

        // Task instructions.
        if (task.description != null) ...[
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('TASK INSTRUCTIONS'),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  task.description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Activity history timeline.
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('ACTIVITY HISTORY'),
              const SizedBox(height: 16),
              ..._timeline(context),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _timeline(BuildContext context) {
    final entries = <(String, String, bool)>[
      if (task.status == TaskStatus.completed)
        ('Completed (Current)', 'Task finished', true),
      if (task.status == TaskStatus.inProgress)
        ('Started (Current)', 'In progress', true),
      ('Assigned', 'Assigned to worker', task.status == TaskStatus.pending),
      (
        'Task Created',
        task.createdAt != null ? _fmtDate(task.createdAt!) : '—',
        false
      ),
    ];

    return [
      for (var i = 0; i < entries.length; i++)
        _timelineRow(
          context,
          title: entries[i].$1,
          subtitle: entries[i].$2,
          active: entries[i].$3,
          isLast: i == entries.length - 1,
        ),
    ];
  }

  Widget _timelineRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool active,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primaryContainer
                      : AppColors.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: active
                    ? const Center(
                        child: CircleAvatar(
                            radius: 4, backgroundColor: Colors.white),
                      )
                    : const Icon(Icons.check,
                        size: 12, color: AppColors.onSurfaceVariant),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.border,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: active
                            ? AppColors.onSurface
                            : AppColors.onSurfaceVariant,
                      )),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.onSurfaceVariant,
        ),
      );

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppColors.onSurfaceVariant,
              )),
          const SizedBox(height: 4),
          Text(value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              )),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
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

  static String _fmtDate(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ampm = d.hour < 12 ? 'AM' : 'PM';
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.month}/${d.day}, $h:$m $ampm';
  }
}
