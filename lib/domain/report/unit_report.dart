
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/report/report.dart';

class UnitReport extends Report{
  String? areaId;
  String? unitId;

  UnitReport({this.areaId, required this.unitId, required Report report}):super(type: ReportType.UNIT,
      creatorId: report.creatorId,
      year: report.year, monthCode: report.monthCode, monthName: report.monthName,
      fields: report.fields);

  UnitReport.fromMap(DocumentSnapshot<Map<String,dynamic>> doc):super.fromMap(doc){
    this.areaId = doc.data()!['areaId'];
    this.unitId = doc.data()!['unitId'];
  }

  toMap(){
    Map<String,dynamic> mapData = super.toMap();
    mapData.addAll({
      'areaId':this.areaId,
      'unitId':this.unitId
    });
    return mapData;
  }
}