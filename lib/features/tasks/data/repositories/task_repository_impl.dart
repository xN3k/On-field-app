import '../../../../core/network/network_info.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required this.remote,
    required this.local,
    required this.network,
  });

  final TaskRemoteDataSource remote;
  final TaskLocalDataSource local;
  final NetworkInfo network;

  @override
  Future<List<Task>> getTasks({required bool forTeam}) async {
    // Read-through: serve cache first, refresh from remote when online.
    if (await network.isOnline) {
      try {
        final tasks = await remote.getTasks();
        await local.cacheAll(tasks);
        return tasks;
      } catch (_) {
        return local.getCached();
      }
    }
    return local.getCached();
  }

  @override
  Future<Task> getTaskById(String id) async {
    if (await network.isOnline) {
      final task = await remote.getById(id);
      await local.upsert(task);
      return task;
    }
    return local.getCached().firstWhere((t) => t.id == id);
  }

  @override
  Future<Task> updateStatus(String id, TaskStatus status) async {
    final updated = await remote.updateStatus(id, status);
    await local.upsert(updated);
    return updated;
  }

  @override
  Stream<List<Task>> watchTasks() =>
      local.watch().map((list) => list.cast<Task>());

  /// Merge a task pushed over the socket into the cache.
  Future<void> applyRemoteUpdate(TaskModel task) => local.upsert(task);
}
