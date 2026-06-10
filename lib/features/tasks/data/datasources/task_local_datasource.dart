import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../models/task_model.dart';

/// Caches tasks as JSON strings keyed by task id.
class TaskLocalDataSource {
  TaskLocalDataSource(this._box);

  final Box<String> _box;

  List<TaskModel> getCached() => _box.values
      .map((s) => TaskModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
      .toList();

  Future<void> cacheAll(List<TaskModel> tasks) async {
    await _box.clear();
    await _box.putAll({for (final t in tasks) t.id: jsonEncode(t.toJson())});
  }

  Future<void> upsert(TaskModel task) async {
    await _box.put(task.id, jsonEncode(task.toJson()));
  }

  Future<void> remove(String id) async {
    await _box.delete(id);
  }

  Stream<List<TaskModel>> watch() async* {
    yield getCached();
    yield* _box.watch().map((_) => getCached());
  }
}
