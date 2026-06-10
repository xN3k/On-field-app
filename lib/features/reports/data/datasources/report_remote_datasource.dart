import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/report_model.dart';

class ReportRemoteDataSource {
  ReportRemoteDataSource(this._dio);

  final Dio _dio;

  /// Submits a single report. The server dedupes on idempotencyKey.
  Future<void> submit(ReportModel report) async {
    await _dio.post<dynamic>(
      ApiConstants.reports,
      data: report.toRequestJson(),
    );
  }

  Future<List<ReportModel>> getReports({
    String? taskId,
    String? userId,
    int page = 1,
    int limit = 50,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiConstants.reports,
      queryParameters: {
        'taskId': ?taskId,
        'userId': ?userId,
        'page': page,
        'limit': limit,
      },
    );
    final data = unwrap<List<dynamic>>(res);
    return data
        .map((e) => ReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ReportModel> getById(String id) async {
    final res =
        await _dio.get<Map<String, dynamic>>(ApiConstants.reportById(id));
    return ReportModel.fromJson(unwrap<Map<String, dynamic>>(res));
  }

  /// Pushes a batch of queued reports through the offline sync endpoint.
  /// Returns the server-assigned batch id (for status tracking).
  Future<String?> syncBatch(List<ReportModel> reports) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiConstants.syncBatch,
      data: {'reports': reports.map((r) => r.toRequestJson()).toList()},
    );
    final data = unwrap<dynamic>(res);
    return data is Map<String, dynamic> ? data['batchId'] as String? : null;
  }
}
