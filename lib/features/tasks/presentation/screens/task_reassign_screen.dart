import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../users/presentation/providers/user_providers.dart';
import '../providers/task_form_provider.dart';
import '../providers/task_list_provider.dart';

/// Pick a new worker for an existing task. Manager/admin only.
class TaskReassignScreen extends ConsumerStatefulWidget {
  const TaskReassignScreen({required this.taskId, super.key});

  final String taskId;

  @override
  ConsumerState<TaskReassignScreen> createState() =>
      _TaskReassignScreenState();
}

class _TaskReassignScreenState extends ConsumerState<TaskReassignScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final task = ref.watch(taskDetailProvider(widget.taskId)).value;
    final workersAsync = ref.watch(workerOptionsProvider);
    final assigning = ref.watch(taskAssignProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Reassign Task')),
      body: workersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load workers: $e')),
        data: (workers) {
          if (workers.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              title: 'No workers available',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: workers.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final w = workers[i];
              final isCurrent = w.id == task?.assignedToId;
              final selected = w.id == _selectedId;
              return Card(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : null,
                child: ListTile(
                  enabled: !isCurrent,
                  leading: AvatarChip(name: w.name ?? w.email),
                  title: Text(w.name ?? w.email),
                  subtitle: Text(isCurrent ? 'Current assignee' : w.email),
                  trailing: selected
                      ? const Icon(Icons.check_circle,
                          color: AppColors.primary)
                      : null,
                  onTap: isCurrent
                      ? null
                      : () => setState(() => _selectedId = w.id),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton(
            onPressed: _selectedId == null || assigning
                ? null
                : () async {
                    final ok = await ref
                        .read(taskAssignProvider.notifier)
                        .assign(widget.taskId, _selectedId!);
                    if (!context.mounted) return;
                    if (ok) {
                      AppToast.success(context, 'Task reassigned');
                      context.pop();
                    } else {
                      AppToast.error(context, 'Reassign failed',
                          message: 'Please try again.');
                    }
                  },
            child: assigning
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Reassign Task'),
          ),
        ),
      ),
    );
  }
}
