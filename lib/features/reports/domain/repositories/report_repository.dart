import '../entities/report.dart';

abstract class ReportRepository {
  /// Write-behind: persists the report locally as PENDING and attempts an
  /// immediate sync. Safe to retry thanks to the idempotency key.
  Future<Report> submitReport({
    required String taskId,
    required Map<String, dynamic> payload,
  });

  /// Pushes all pending/failed reports to the server.
  /// Returns the sync batch id when a batch was submitted.
  Future<String?> syncPending();

  /// Server-side report history, merged with the local unsynced queue.
  Future<List<Report>> fetchReports({String? taskId, String? userId});

  /// Single report by server id, falling back to the local queue.
  Future<Report?> getReport(String id);

  /// Count of reports not yet synced (for the badge).
  int pendingCount();

  /// Emits whenever the local report queue changes.
  Stream<List<Report>> watchReports();
}
