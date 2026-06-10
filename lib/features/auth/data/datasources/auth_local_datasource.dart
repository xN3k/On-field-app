import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../models/user_model.dart';

/// Caches the authenticated user profile (tokens live in SecureStorage).
class AuthLocalDataSource {
  AuthLocalDataSource(this._box);

  final Box<String> _box;
  static const _key = 'current';

  Future<void> cacheUser(UserModel user) async {
    await _box.put(_key, jsonEncode(user.toJson()));
  }

  UserModel? getCachedUser() {
    final raw = _box.get(_key);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clear() => _box.delete(_key);
}
