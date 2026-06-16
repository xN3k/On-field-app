import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../models/app_notification_model.dart';

/// Persists notifications as JSON strings keyed by id, capped at [_max].
class NotificationLocalDataSource {
  NotificationLocalDataSource(this._box);

  final Box<String> _box;

  static const _max = 100;

  List<AppNotificationModel> getAll() {
    final items = <AppNotificationModel>[];
    final junkKeys = <dynamic>[];
    for (final key in _box.keys) {
      final raw = _box.get(key);
      final n = raw == null ? null : _tryParse(raw);
      // Drop only truly malformed (unparseable) entries. Parseable rows always
      // render via displayTitle/displayBody, which derive a type-based label
      // when the stored title/body is empty (older schema / bad payloads).
      if (n != null) {
        items.add(n);
      } else {
        junkKeys.add(key);
      }
    }
    if (junkKeys.isNotEmpty) {
      _box.deleteAll(junkKeys); // fire-and-forget cleanup
    }
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  AppNotificationModel? _tryParse(String s) {
    try {
      return AppNotificationModel.fromJson(
          jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> add(AppNotificationModel notification) async {
    await _box.put(notification.id, jsonEncode(notification.toJson()));
    await _trim();
  }

  Future<void> markRead(String id) async {
    final raw = _box.get(id);
    if (raw == null) return;
    final n = AppNotificationModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>);
    await _box.put(
      id,
      jsonEncode(AppNotificationModel.fromEntity(n.copyWith(read: true))
          .toJson()),
    );
  }

  Future<void> markAllRead() async {
    for (final n in getAll().where((n) => !n.read)) {
      await markRead(n.id);
    }
  }

  Future<void> _trim() async {
    final all = getAll();
    if (all.length <= _max) return;
    for (final n in all.sublist(_max)) {
      await _box.delete(n.id);
    }
  }

  Stream<List<AppNotificationModel>> watch() async* {
    yield getAll();
    yield* _box.watch().map((_) => getAll());
  }
}
