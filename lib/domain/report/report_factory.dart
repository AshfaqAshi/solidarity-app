
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/report/area_report.dart';
import 'package:solidarity_app/domain/report/field.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/report/report_repository_base.dart';
import 'package:solidarity_app/domain/report/unit_report.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';
import 'package:solidarity_app/infrastructure/report/report_repository.dart';

class ReportFactory implements ReportRepositoryBase{
  ReportFactory._();

  static ReportFactory get instance {
    if(_instance==null) _instance = ReportFactory._();
    return _instance!;
  }

  static ReportFactory? _instance;

  ReportRepository reportRepo = ReportRepository();

  List<AreaReport> _areaReports= [];
  List<UnitReport> _unitReports=[];
  List<Field> _areaFields=[];
  List<Field> _unitFields=[];

  List<AreaReport> get areaReports=>_areaReports;
  List<UnitReport> get unitReports=>_unitReports;
  List<Field> get areaFields=>_areaFields;
  List<Field> get unitFields=>_unitFields;

  @override
  Future<Result<List<Report>>> getReports(String type, int year,{String? areaId, String? unitId})async {
    var result = await reportRepo.getReports(type, year,areaId: areaId,unitId: unitId);
    if(result.success){
      if(type==ReportType.AREA){
        _areaReports = List.from(result.value!);
      }else{
        _unitReports = List.from(result.value!);
      }
    }
    return result;
  }

  @override
  Future<Result<Report>> getReportForMonth(String type, int year,int month, {String? areaId, String? unitId})async {

    var result = await reportRepo.getReportForMonth(type, year, month,unitId: unitId,areaId: areaId);
    return result;
  }

  @override
  Future<Result<List<Field>>> getFields(String type,{bool reFetch=false}) async{
    Result<List<Field>> result;
    ///If the respective field list is empty, pull from server. Else, if [reFetch]
    ///is false, return the locally saved list
    if(type==ReportType.AREA){
      if(_areaFields.isEmpty || reFetch){
        result =await reportRepo.getFields(type);
        if(result.success){
          _areaFields = List.from(result.value!);
        }
      }else{
        result = Result(_areaFields);
      }
    }else{
      if(_unitFields.isEmpty || reFetch){
        result =await reportRepo.getFields(type);
        if(result.success){
          _unitFields = List.from(result.value!);
        }
      }else{
        result = Result(_unitFields);
      }
    }
    return result;
  }

  @override
  Future<Result<Report>> removeReport(Report report)async {
    var result = await reportRepo.removeReport(report);
    if(result.success){
      if(report.type==ReportType.AREA){
        int index = _areaReports.indexWhere((data)=>data.id==report.id);
        if(index>=0){
          _areaReports.removeAt(index);
        }
      }else{
        int index = _unitReports.indexWhere((data)=>data.id==report.id);
        if(index>=0){
          _unitReports.removeAt(index);
        }
      }
    }
    return result;
  }

  @override
  Future<Result<Report>> updateReport(Report report)async {
    var result = await reportRepo.updateReport(report);
    if(result.success){
      if(report.type==ReportType.AREA){
        int index = _areaReports.indexWhere((data)=>data.id==report.id);
        if(index>=0){
          _areaReports[index]=report as AreaReport;
        }
      }else{
        int index = _unitReports.indexWhere((data)=>data.id==report.id);
        if(index>=0){
          _unitReports[index]=report as UnitReport;
        }
      }
    }
    return result;
  }

  @override
  Future<Result<Report>> addReport(Report report) async {
    var result = await reportRepo.addReport(report);
    if(result.success){
      if(report.type==ReportType.AREA){
        _areaReports.insert(0,report as AreaReport);
      }else{
        _unitReports.insert(0,report as UnitReport);
      }
    }
    return result;
  }

  @override
  Future<Result<Report>> getReferredDetails(Report report) async {
    var result = await reportRepo.getReferredDetails(report);
    if(result.success){
      if(report.type==ReportType.AREA){
        int index = _areaReports.indexWhere((data)=>data.id==report.id);
        if(index>=0){
          _areaReports[index]=result.value! as AreaReport;
        }
      }else{
        int index = _unitReports.indexWhere((data)=>data.id==report.id);
        if(index>=0){
          _unitReports[index]=result.value! as UnitReport;
        }
      }

    }
    return result;
  }


}