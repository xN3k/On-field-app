import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/core_providers.dart';
import '../../../auth/domain/entities/user.dart';
import '../../data/datasources/user_remote_datasource.dart';

part 'user_providers.g.dart';

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) =>
    UserRemoteDataSource(ref.watch(dioProvider));

/// Full user directory (manager/admin only on the backend).
@riverpod
class UserList extends _$UserList {
  @override
  Future<List<User>> build() =>
      ref.watch(userRemoteDataSourceProvider).getUsers();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(userRemoteDataSourceProvider).getUsers(),
    );
  }

  Future<void> updateUser(String id, Map<String, dynamic> patch) async {
    await ref.read(userRemoteDataSourceProvider).updateUser(id, patch);
    await refresh();
  }
}

@riverpod
Future<User> userDetail(Ref ref, String userId) =>
    ref.watch(userRemoteDataSourceProvider).getById(userId);

/// Workers available for assignment pickers.
@riverpod
Future<List<User>> workerOptions(Ref ref) async {
  final users = await ref.watch(userListProvider.future);
  return users.where((u) => u.role == Role.worker).toList();
}

/// Quick userId → display name lookup for cards and map pins.
@riverpod
Future<Map<String, User>> userDirectory(Ref ref) async {
  final users = await ref.watch(userListProvider.future);
  return {for (final u in users) u.id: u};
}
