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
  Future<User?> currentUser() async {
    final cached = local.getCachedUser();
    if (cached != null) return cached;
    if (await hasSession()) {
      try {
        final user = await remote.me();
        await local.cacheUser(user);
        return user;
      } catch (_) {
        // Stale/expired session that couldn't be refreshed — treat as
        // logged-out rather than crashing the bootstrap.
        await storage.clear();
        return null;
      }
    }
    return null;
  }

  @override
  Future<bool> hasSession() async =>
      (await storage.readAccessToken()) != null;
}
