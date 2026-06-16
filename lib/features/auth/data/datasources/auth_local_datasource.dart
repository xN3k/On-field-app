import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../models/user_model.dart';

/// Caches the authenticated user profile (tokens live in SecureStorage).
class AuthLocalDataSource {
  AuthLocalDataSource(this._box);

  final Box<String> _box;
  static const _key = 'current';
  static const _installedKey = 'installed_flag';

  Future<void> cacheUser(UserModel user) async {
    await _box.put(_key, jsonEncode(user.toJson()));
  }

  UserModel? getCachedUser() {
    final raw = _box.get(_key);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clear() => _box.delete(_key);

  /// True until [markInstalled] runs. Hive lives in the app's data directory,
  /// which the OS wipes on uninstall — so a missing flag means this is a fresh
  /// install (and any tokens left in the iOS Keychain are stale).
  bool isFreshInstall() => _box.get(_installedKey) == null;

  Future<void> markInstalled() => _box.put(_installedKey, '1');
}
