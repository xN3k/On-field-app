import '../entities/task.dart';

abstract class TaskRepository {
  /// Read-through: returns cache immediately if present, refreshes from remote
  /// when online.
  Future<List<Task>> getTasks({required bool forTeam});

  Future<Task> getTaskById(String id);

  Future<Task> updateStatus(String id, TaskStatus status);

  /// Emits whenever the local task cache changes (remote fetch or socket push).
  Stream<List<Task>> watchTasks();
}
