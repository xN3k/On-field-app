import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../di/core_providers.dart';
import '../network/dio_client.dart';
import 'sync_batch_status.dart';

part 'sync_status_providers.g.dart';

const _batchIdsKey = 'batch_ids';
const _maxTrackedBatches = 20;

/// Records submitted batch ids in the sync meta box (most recent first).
Future<void> recordBatchId(Box<String> box, String batchId) async {
  final ids = readBatchIds(box);
  ids.remove(batchId);
  ids.insert(0, batchId);
  await box.put(
    _batchIdsKey,
    jsonEncode(ids.take(_maxTrackedBatches).toList()),
  );
}

List<String> readBatchIds(Box<String> box) {
  final raw = box.get(_batchIdsKey);
  if (raw == null) return [];
  return (jsonDecode(raw) as List<dynamic>).cast<String>();
}

/// Statuses of the recently submitted sync batches, newest first.
@riverpod
class SyncBatches extends _$SyncBatches {
  @override
  Future<List<SyncBatchStatus>> build() => _fetch();

  Future<List<SyncBatchStatus>> _fetch() async {
    final ids = readBatchIds(ref.read(syncMetaBoxProvider));
    final dio = ref.read(dioProvider);
    final statuses = <SyncBatchStatus>[];
    for (final id in ids) {
      try {
        final res = await dio
            .get<Map<String, dynamic>>(ApiConstants.syncBatchById(id));
        statuses.add(
          SyncBatchStatus.fromJson(unwrap<Map<String, dynamic>>(res)),
        );
      } on DioException {
        // Skip batches the server no longer knows (or offline).
      }
    }
    return statuses;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}
