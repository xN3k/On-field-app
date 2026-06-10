import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/task.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  TaskRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<TaskModel>> getTasks({
    String? assignedToId,
    TaskStatus? status,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiConstants.tasks,
      queryParameters: {
        'limit': 100,
        'assignedToId': ?assignedToId,
        'status': ?status?.wire,
      },
    );
    final data = unwrap<List<dynamic>>(res);
    return data
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<TaskModel> createTask(Map<String, dynamic> body) async {
    final res =
        await _dio.post<Map<String, dynamic>>(ApiConstants.tasks, data: body);
    return TaskModel.fromJson(unwrap<Map<String, dynamic>>(res));
  }

  Future<TaskModel> updateTask(String id, Map<String, dynamic> patch) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      ApiConstants.taskById(id),
      data: patch,
    );
    return TaskModel.fromJson(unwrap<Map<String, dynamic>>(res));
  }

  Future<TaskModel> assignTask(String id, String assignedToId) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      ApiConstants.taskAssign(id),
      data: {'assignedToId': assignedToId},
    );
    return TaskModel.fromJson(unwrap<Map<String, dynamic>>(res));
  }

  Future<void> deleteTask(String id) async {
    await _dio.delete<dynamic>(ApiConstants.taskById(id));
  }

  Future<TaskModel> getById(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(ApiConstants.taskById(id));
    return TaskModel.fromJson(unwrap<Map<String, dynamic>>(res));
  }

  Future<TaskModel> updateStatus(String id, TaskStatus status) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      ApiConstants.taskStatus(id),
      data: {'status': status.wire},
    );
    return TaskModel.fromJson(unwrap<Map<String, dynamic>>(res));
  }
}
