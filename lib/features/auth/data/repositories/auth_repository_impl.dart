import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remote,
    required this.local,
    required this.storage,
  });

  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;
  final SecureStorage storage;

  @override
  Future<AuthSession> login(String email, String password) async {
    final result = await remote.login(email, password);
    await storage.saveTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );
    await local.cacheUser(result.user);
    return AuthSession(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
      user: result.user,
    );
  }

  @override
  Future<void> logout() async {
    await storage.clear();
    await local.clear();
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await remote.changePassword(currentPassword, newPassword);
  }

  @override
  Future<User?> currentUser() async {
    // On a fresh install the Hive cache is gone but the iOS Keychain survives,
    // so any tokens it still holds belong to a previous install — purge them
    // before we'd ever trust them.
    if (local.isFreshInstall()) {
      await storage.clear();
      await local.clear();
      await local.markInstalled();
      return null;
    }

    // No token at all → definitely logged out; skip the network round-trip.
    if (!await hasSession()) return null;

    // The backend is the single source of truth. Always verify the token with
    // /auth/me — a locally cached user is never trusted on its own. The Dio
    // auth interceptor transparently refreshes a 401 and retries; if that also
    // fails, me() throws and we clear the (now-invalid) session.
    try {
      final user = await remote.me();
      await local.cacheUser(user);
      return user;
    } catch (_) {
      await storage.clear();
      await local.clear();
      return null;
    }
  }

  @override
  Future<bool> hasSession() async =>
      (await storage.readAccessToken()) != null;
}
