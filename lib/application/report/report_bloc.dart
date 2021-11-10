import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/report/area_report.dart';
import 'package:solidarity_app/domain/report/field.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/report/report_factory.dart';
import 'package:solidarity_app/domain/report/unit_report.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial());

  ReportFactory reportFactory = ReportFactory.instance;


  List<AreaReport> get areaReports => reportFactory.areaReports;
  List<UnitReport> get unitReports=> reportFactory.unitReports;

  @override
  Stream<ReportState> mapEventToState(
    ReportEvent event,
  ) async* {

    if(event is GetReportsEvent){
      yield GetReportsState();
      var result = await reportFactory.getReports(event.type, event.year,areaId: event.areaId,unitId: event.unitId);
      yield GetReportsCompleteState(result);
    }else if(event is GetReportForMonthEvent){
      yield GetReportForMonthState(event.type,areaId: event.areaId,unitId: event.unitId);
      var result = await reportFactory.getReportForMonth(event.type, event.year,event.monthCode,
      areaId: event.areaId, unitId: event.unitId);
      yield GetReportForMonthCompleteState(result,event.type,areaId: event.areaId,unitId: event.unitId);
    }else if(event is AddReportEvent){
      yield AddReportState();
      var result = await reportFactory.addReport(event.report);
      yield AddReportCompleteState(result);
    }else if(event is UpdateReportEvent){
      yield UpdateReportState();
      var result = await reportFactory.updateReport(event.report);
      yield UpdateReportCompleteState(result);
    }else if(event is DeleteReportEvent){
      yield DeleteReportState();
      var result = await reportFactory.removeReport(event.report);
      yield DeleteReportCompleteState(result);
    }else if(event is GetFieldsEvent){
      yield GetFieldsState();
      var result = await reportFactory.getFields(event.type);
      yield GetFieldsCompleteState(result);
    }else if(event is GetReferenceDetailsEvent){
      yield GetReferenceDetailsState();
      var result = await reportFactory.getReferredDetails(event.report);
      yield GetReferenceDetailsCompleteState(result);
    }
  }
}
