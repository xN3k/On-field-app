enum SyncStatus {
  pending,
  synced,
  failed;

  static SyncStatus fromString(String value) => switch (value.toUpperCase()) {
        'SYNCED' => SyncStatus.synced,
        'FAILED' => SyncStatus.failed,
        _ => SyncStatus.pending,
      };

  String get wire => name.toUpperCase();
}

class Report {
  const Report({
    required this.idempotencyKey,
    required this.taskId,
    required this.payload,
    required this.syncStatus,
    this.id,
    this.userId,
    this.createdAt,
    this.retryCount = 0,
  });

  /// Client-generated; stable across retries so the server can dedupe.
  final String idempotencyKey;
  final String? id;
  final String taskId;
  final String? userId;
  final Map<String, dynamic> payload;
  final SyncStatus syncStatus;
  final DateTime? createdAt;
  final int retryCount;

  Report copyWith({SyncStatus? syncStatus, int? retryCount, String? id}) =>
      Report(
        idempotencyKey: idempotencyKey,
        id: id ?? this.id,
        taskId: taskId,
        userId: userId,
        payload: payload,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt,
        retryCount: retryCount ?? this.retryCount,
      );
}
