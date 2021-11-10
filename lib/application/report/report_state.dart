part of 'report_bloc.dart';

@immutable
abstract class ReportState {
}

class ReportInitial extends ReportState {}

class GetReportsState extends ReportState{}

class GetReportsCompleteState extends ReportState{
  final Result<List<Report>> result;
  GetReportsCompleteState(this.result);

}

class GetReportForMonthState extends ReportState{
  final String? areaId;
  final String? unitId;
  final String type;
///All these fields are required for this State because its corresponding event
///will be called several times (as many areas are loaded in the area list) simultaneously.
///So in order for the correct [builder] function to be called out of the several listeners
///of the builder function, all these extra fields are required
GetReportForMonthState(this.type,{this.unitId,this.areaId});
}

class GetReportForMonthCompleteState extends ReportState{
  final Result<Report> result;
  final String? areaId;
  final String? unitId;
  final String type;
  ///All these fields are required for this State because its corresponding event
  ///will be called several times (as many areas are loaded in the area list) simultaneously.
  ///So in order for the correct [builder] function to be called out of the several listeners
  ///of the builder function, all these extra fields are required
  GetReportForMonthCompleteState(this.result,this.type,{this.areaId,this.unitId});
}

class AddReportState extends ReportState{
}

class AddReportCompleteState extends ReportState{
  final Result<Report> result;
  AddReportCompleteState(this.result);
}

class UpdateReportState extends ReportState{
}

class UpdateReportCompleteState extends ReportState{
  final Result<Report> result;
  UpdateReportCompleteState(this.result);
}

class DeleteReportState extends ReportState{
}

class DeleteReportCompleteState extends ReportState{
  final Result<Report> result;
  DeleteReportCompleteState(this.result);
}

class GetReferenceDetailsState extends ReportState{
}

class GetReferenceDetailsCompleteState extends ReportState{
  final Result<Report> result;
  GetReferenceDetailsCompleteState(this.result);
}

class GetFieldsState extends ReportState{}
class GetFieldsCompleteState extends ReportState{
  final Result<List<Field>> fields;
  GetFieldsCompleteState(this.fields);
}
