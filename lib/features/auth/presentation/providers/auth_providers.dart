import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/core_providers.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSource(ref.watch(dioProvider));

@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) =>
    AuthLocalDataSource(ref.watch(userBoxProvider));

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      remote: ref.watch(authRemoteDataSourceProvider),
      local: ref.watch(authLocalDataSourceProvider),
      storage: ref.watch(secureStorageProvider),
    );
