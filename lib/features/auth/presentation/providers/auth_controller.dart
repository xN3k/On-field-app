import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/core_providers.dart';
import '../../domain/entities/user.dart';
import 'auth_providers.dart';

part 'auth_controller.g.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState(this.status, [this.user]);
  const AuthState.unknown() : this(AuthStatus.unknown, null);

  final AuthStatus status;
  final User? user;

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

/// Holds the session and drives router redirects. Kept alive for the app's
/// lifetime so the socket connection and session survive navigation.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<AuthState> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final user = await repo.currentUser();
    if (user != null) {
      _connectSocket();
      return AuthState(AuthStatus.authenticated, user);
    }
    return const AuthState(AuthStatus.unauthenticated);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session =
          await ref.read(authRepositoryProvider).login(email, password);
      _connectSocket();
      return AuthState(AuthStatus.authenticated, session.user);
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    ref.read(socketServiceProvider).disconnect();
    state = const AsyncData(AuthState(AuthStatus.unauthenticated));
  }

  /// Invoked by the Dio interceptor when token refresh fails.
  Future<void> forceLogout() async {
    state = const AsyncData(AuthState(AuthStatus.unauthenticated));
  }

  Future<void> _connectSocket() async {
    final token = await ref.read(secureStorageProvider).readAccessToken();
    if (token != null) {
      ref.read(socketServiceProvider).connect(token);
    }
  }
}
