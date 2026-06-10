import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/location_ping_model.dart';

/// Buffers location pings while offline, keyed by a generated id.
class LocationLocalDataSource {
  LocationLocalDataSource(this._box);

  final Box<String> _box;
  static const _uuid = Uuid();

  Future<void> buffer(LocationPingModel ping) async {
    await _box.put(_uuid.v4(), jsonEncode(ping.toJson()));
  }

  List<LocationPingModel> drain() {
    final pings = _box.values
        .map((s) =>
            LocationPingModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    return pings;
  }

  Future<void> clear() => _box.clear();

  bool get isEmpty => _box.isEmpty;
}
