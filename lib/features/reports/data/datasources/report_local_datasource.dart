import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../../domain/entities/report.dart';
import '../models/report_model.dart';

/// Queues reports as JSON strings keyed by idempotencyKey (dedupe + safe retry).
class ReportLocalDataSource {
  ReportLocalDataSource(this._box);

  final Box<String> _box;

  List<ReportModel> getAll() => _box.values
      .map((s) => ReportModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
      .toList();

  List<ReportModel> getPending() => getAll()
      .where((r) => r.syncStatus != SyncStatus.synced)
      .toList();

  int pendingCount() =>
      getAll().where((r) => r.syncStatus != SyncStatus.synced).length;

  Future<void> put(ReportModel report) async {
    await _box.put(report.idempotencyKey, jsonEncode(report.toJson()));
  }

  Stream<List<ReportModel>> watch() async* {
    yield getAll();
    yield* _box.watch().map((_) => getAll());
  }
}
