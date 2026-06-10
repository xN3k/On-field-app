import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/core_providers.dart';
import '../../data/datasources/task_local_datasource.dart';
import '../../data/datasources/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';

part 'task_providers.g.dart';

@riverpod
TaskRemoteDataSource taskRemoteDataSource(Ref ref) =>
    TaskRemoteDataSource(ref.watch(dioProvider));

@riverpod
TaskLocalDataSource taskLocalDataSource(Ref ref) =>
    TaskLocalDataSource(ref.watch(tasksBoxProvider));

@riverpod
TaskRepository taskRepository(Ref ref) => TaskRepositoryImpl(
      remote: ref.watch(taskRemoteDataSourceProvider),
      local: ref.watch(taskLocalDataSourceProvider),
      network: ref.watch(networkInfoProvider),
    );
