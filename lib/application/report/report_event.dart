part of 'report_bloc.dart';

@immutable
abstract class ReportEvent {}

class GetReportsEvent extends ReportEvent{
  final int year;
  final String type;
  final String? areaId;
  final String? unitId;
  GetReportsEvent(this.year,this.type,{this.areaId,this.unitId});
}

class GetReportForMonthEvent extends ReportEvent{
  final int year;
  final String type;
  final String? areaId;
  final String? unitId;
  final int monthCode;
  GetReportForMonthEvent(this.type,this.year,this.monthCode,{this.areaId,this.unitId});
}

class AddReportEvent extends ReportEvent{
  final Report report;
  AddReportEvent(this.report);
}

class UpdateReportEvent extends ReportEvent{
  final Report report;
  UpdateReportEvent(this.report);
}

class DeleteReportEvent extends ReportEvent{
  final Report report;
  DeleteReportEvent(this.report);
}

class GetFieldsEvent extends ReportEvent{
  final String type;
  GetFieldsEvent(this.type);
}

class GetReferenceDetailsEvent extends ReportEvent{
  final Report report;
  GetReferenceDetailsEvent(this.report);
}

