import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/hive_constants.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../socket/socket_service.dart';
import '../storage/hive_init.dart';
import '../storage/secure_storage.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) => SecureStorage();

@Riverpod(keepAlive: true)
NetworkInfo networkInfo(Ref ref) => NetworkInfo();

/// Live connectivity flag; seeds with the current state then follows changes.
@Riverpod(keepAlive: true)
Stream<bool> isOnline(Ref ref) async* {
  final info = ref.watch(networkInfoProvider);
  yield await info.isOnline;
  yield* info.onStatusChange;
}

@Riverpod(keepAlive: true)
SocketService socketService(Ref ref) {
  final service = SocketService();
  ref.onDispose(service.disconnect);
  return service;
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return buildDio(
    storage: ref.watch(secureStorageProvider),
    onRefreshFailed: () async {
      // Refresh failed → force the session back to logged-out so the router
      // redirects to login. Deferred via microtask so that if this fires
      // while AuthController.build() is still in flight (e.g. the bootstrap
      // /auth/me call 401s), we don't read the provider during its own build
      // and trigger a CircularDependencyError.
      Future.microtask(
        () => ref.read(authControllerProvider.notifier).forceLogout(),
      );
    },
  );
}

// --- Hive boxes -------------------------------------------------------------

@Riverpod(keepAlive: true)
Box<String> userBox(Ref ref) => HiveInit.box(HiveConstants.userBox);

@Riverpod(keepAlive: true)
Box<String> tasksBox(Ref ref) => HiveInit.box(HiveConstants.tasksBox);

@Riverpod(keepAlive: true)
Box<String> reportsBox(Ref ref) => HiveInit.box(HiveConstants.reportsBox);

@Riverpod(keepAlive: true)
Box<String> locationBox(Ref ref) => HiveInit.box(HiveConstants.locationBox);

@Riverpod(keepAlive: true)
Box<String> syncMetaBox(Ref ref) => HiveInit.box(HiveConstants.syncMetaBox);

@Riverpod(keepAlive: true)
Box<String> notificationsBox(Ref ref) =>
    HiveInit.box(HiveConstants.notificationsBox);
