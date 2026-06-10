import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../models/app_notification_model.dart';

/// Persists notifications as JSON strings keyed by id, capped at [_max].
class NotificationLocalDataSource {
  NotificationLocalDataSource(this._box);

  final Box<String> _box;

  static const _max = 100;

  List<AppNotificationModel> getAll() {
    final items = _box.values
        .map((s) =>
            AppNotificationModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
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
