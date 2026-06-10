import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
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

  /// Pushes a batch of queued reports through the offline sync endpoint.
  Future<void> syncBatch(List<ReportModel> reports) async {
    await _dio.post<dynamic>(
      ApiConstants.syncBatch,
      data: {'reports': reports.map((r) => r.toRequestJson()).toList()},
    );
  }
}
