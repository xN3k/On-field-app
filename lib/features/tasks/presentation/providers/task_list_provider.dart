import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/entities/task.dart';
import 'task_providers.dart';

part 'task_list_provider.g.dart';

@riverpod
class TaskList extends _$TaskList {
  bool get _forTeam =>
      ref.read(authControllerProvider).value?.user?.role.isManager ??
      false;

  @override
  Future<List<Task>> build() {
    return ref.watch(taskRepositoryProvider).getTasks(forTeam: _forTeam);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(taskRepositoryProvider).getTasks(forTeam: _forTeam),
    );
  }

  Future<void> updateStatus(String id, TaskStatus status) async {
    state = await AsyncValue.guard(() async {
      await ref.read(taskRepositoryProvider).updateStatus(id, status);
      return ref.read(taskRepositoryProvider).getTasks(forTeam: _forTeam);
    });
  }
}

@riverpod
Future<Task> taskDetail(Ref ref, String id) {
  return ref.watch(taskRepositoryProvider).getTaskById(id);
}
