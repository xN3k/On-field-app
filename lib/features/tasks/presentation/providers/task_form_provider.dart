import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/task.dart';
import 'task_list_provider.dart';
import 'task_providers.dart';

part 'task_form_provider.g.dart';

/// Create / edit / delete controller for manager task writes (online-only).
@riverpod
class TaskForm extends _$TaskForm {
  @override
  AsyncValue<Task?> build() => const AsyncData(null);

  Future<bool> create(Map<String, dynamic> body) => _run(
        () => ref.read(taskRepositoryProvider).createTask(body),
      );

  Future<bool> update(String id, Map<String, dynamic> patch) => _run(
        () => ref.read(taskRepositoryProvider).updateTask(id, patch),
      );

  Future<bool> delete(String id) => _run(() async {
        await ref.read(taskRepositoryProvider).deleteTask(id);
        return null;
      });

  Future<bool> _run(Future<Task?> Function() op) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(op);
    if (state.hasError) return false;
    ref.invalidate(taskListProvider);
    return true;
  }
}

/// Reassignment controller.
@riverpod
class TaskAssign extends _$TaskAssign {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> assign(String taskId, String assignedToId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(taskRepositoryProvider).assignTask(taskId, assignedToId),
    );
    if (state.hasError) return false;
    ref
      ..invalidate(taskListProvider)
      ..invalidate(taskDetailProvider(taskId));
    return true;
  }
}
