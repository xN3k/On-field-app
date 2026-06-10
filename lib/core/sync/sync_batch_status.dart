/// Status of an offline sync batch as reported by GET /sync/batch/:id.
class SyncBatchStatus {
  const SyncBatchStatus({
    required this.id,
    required this.status,
    this.itemCount = 0,
    this.processedCount = 0,
    this.failedCount = 0,
    this.error,
    this.createdAt,
  });

  final String id;

  /// PENDING | PROCESSING | COMPLETED | FAILED (wire strings).
  final String status;
  final int itemCount;
  final int processedCount;
  final int failedCount;
  final String? error;
  final DateTime? createdAt;

  factory SyncBatchStatus.fromJson(Map<String, dynamic> json) =>
      SyncBatchStatus(
        id: json['id'] as String,
        status: (json['status'] as String? ?? 'PENDING').toUpperCase(),
        itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
        processedCount: (json['processedCount'] as num?)?.toInt() ?? 0,
        failedCount: (json['failedCount'] as num?)?.toInt() ?? 0,
        error: json['error'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
}
