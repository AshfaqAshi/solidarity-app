
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/report/field.dart';
import 'package:solidarity_app/domain/report/report.dart';

class AreaReport extends Report{
  String? areaId;

  AreaReport({this.areaId, required Report report}):super(type: ReportType.AREA,
  creatorId: report.creatorId,
  year: report.year, monthCode: report.monthCode, monthName: report.monthName,
  fields: report.fields);

  AreaReport.fromMap(DocumentSnapshot<Map<String,dynamic>> doc):super.fromMap(doc){
    this.areaId = doc.data()!['areaId'];
  }

  toMap(){
    Map<String,dynamic> mapData = super.toMap();
    mapData.addAll({
      'areaId':this.areaId,
    });
    return mapData;
  }



}