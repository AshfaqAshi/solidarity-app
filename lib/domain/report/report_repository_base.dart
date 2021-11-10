
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/report/field.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/report/unit_report.dart';

abstract class ReportRepositoryBase{
  Future<Result<List<Report>>> getReports(String type,int year,{String? areaId, String? unitId});
  Future<Result<Report>> getReportForMonth(String type,int year,int month,{String? areaId, String? unitId});
  Future<Result<Report>> updateReport(Report report);
  Future<Result<Report>> removeReport(Report report);
  Future<Result<Report>> addReport(Report report);
  Future<Result<Report>> getReferredDetails(Report report);
  Future<Result<List<Field>>> getFields(String type);
}