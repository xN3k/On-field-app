import '../../domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.idempotencyKey,
    required super.taskId,
    required super.payload,
    required super.syncStatus,
    super.id,
    super.userId,
    super.createdAt,
    super.retryCount,
  });

  factory ReportModel.fromEntity(Report r) => ReportModel(
        idempotencyKey: r.idempotencyKey,
        taskId: r.taskId,
        payload: r.payload,
        syncStatus: r.syncStatus,
        id: r.id,
        userId: r.userId,
        createdAt: r.createdAt,
        retryCount: r.retryCount,
      );

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        idempotencyKey:
            (json['idempotencyKey'] ?? json['id']) as String,
        taskId: json['taskId'] as String,
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        syncStatus:
            SyncStatus.fromString(json['syncStatus'] as String? ?? 'PENDING'),
        id: json['id'] as String?,
        userId: json['userId'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      );

  /// Local Hive representation.
  Map<String, dynamic> toJson() => {
        'idempotencyKey': idempotencyKey,
        'taskId': taskId,
        'payload': payload,
        'syncStatus': syncStatus.wire,
        'id': id,
        'userId': userId,
        'createdAt': createdAt?.toIso8601String(),
        'retryCount': retryCount,
      };

  /// Body shape accepted by POST /reports and the sync batch.
  Map<String, dynamic> toRequestJson() => {
        'taskId': taskId,
        'payload': payload,
        'idempotencyKey': idempotencyKey,
      };
}
