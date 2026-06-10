import '../entities/auth_session.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthSession> login(String email, String password);
  Future<void> logout();

  /// Returns the cached user if a valid session exists, else null.
  Future<User?> currentUser();

  /// True if an access token is present in secure storage.
  Future<bool> hasSession();
}
