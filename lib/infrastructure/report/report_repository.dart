

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/core/google_sheet.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/report/area_report.dart';
import 'package:solidarity_app/domain/report/field.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/report/report_repository_base.dart';
import 'package:solidarity_app/domain/report/unit_report.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';
import 'package:solidarity_app/infrastructure/core/general_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:solidarity_app/infrastructure/user/user_repository.dart';
class ReportRepository implements ReportRepositoryBase{


  UserFactory userFactory = UserFactory.instance;

  CollectionReference<Report> _getReportsRef(String type,{String? areaId, String? unitId}){

    if(type==ReportType.AREA){
      return GeneralRepository.getOrgDoc().collection(Collection.AREAS)
      .doc(areaId!).collection(Collection.REPORTS)
          .withConverter<AreaReport>(fromFirestore: (snap,options)=>AreaReport.fromMap(snap),
          toFirestore: (report, options)=>report.toMap());
    }
    return GeneralRepository.getOrgDoc().collection(Collection.AREAS)
    .doc(areaId!).collection(Collection.UNITS).doc(unitId!).collection(Collection.REPORTS)
        .withConverter<UnitReport>(fromFirestore: (snap,options)=>UnitReport.fromMap(snap),
    toFirestore: (report, options)=>report.toMap());

  }

  @override
  Future<Result<List<Report>>> getReports(String type, int year,{ String? areaId, String? unitId, int limit=25,})async {
   try{
     late QuerySnapshot<Report> snap;
     if(unitId==null){
       //fetch area reports
       snap = await _getReportsRef(type, areaId: areaId).where('year',isEqualTo: year)
           .orderBy('time',descending: true).limit(limit)
           .get();
     }else{
       snap = await _getReportsRef(type, unitId: unitId, areaId: areaId).where('year',isEqualTo: year)
           .orderBy('time',descending: true).limit(limit)
           .get();
       /*snap = await _getReportsRef(type).where('type',isEqualTo: type).where('year',isEqualTo: year)
           .orderBy('time',descending: true).endBefore([endBefore])
           .get();*/
     }
     List<Report> reports;
     if(type==ReportType.UNIT){
       reports = <UnitReport>[];
     }else{
       reports = <AreaReport>[];
     }
     snap.docs.forEach((doc){
       reports.add(doc.data());
     });
     return Result(reports);
   }catch(ex,stack){
     print('err ${stack.toString()}');
     return Result(null,success: false, userMessage: 'Failed to get the reports!', message: ex.toString());
   }
  }

  @override
  Future<Result<Report>> getReportForMonth(String type, int year, int month,{String? areaId, String? unitId}) async{
    try{

       QuerySnapshot<Report> snap;

       if(unitId==null){
         //its an area report fetch
         snap =await _getReportsRef(type, areaId: areaId).where('year',isEqualTo: year)
             .where('monthCode',isEqualTo: month)
             .orderBy('time',descending: true)
         .limit(1)
             .get();
       }else{
         snap =await _getReportsRef(type,unitId: unitId,areaId: areaId).where('year',isEqualTo: year)
             .where('monthCode',isEqualTo: month)
             .orderBy('time',descending: true)
         .limit(1)
             .get();
       }

      if(snap.docs.isEmpty){
        return Result(null,errorCode: ErrorCodes.NO_DATA,success: false);
      }else{
        if(type==ReportType.AREA){
          AreaReport report=snap.docs[0].data() as AreaReport;
          return Result(report);
        }else{
          UnitReport report=snap.docs[0].data() as UnitReport;
          return Result(report);
        }
      }


    }catch(ex, stack){
      print('unit id received ${unitId} ${ex.toString()}');
      print('errorr ${stack.toString()}');
      return Result(null,success: false, userMessage: 'Failed to get the reports!', message: ex.toString());
    }
  }

  @override
  Future<Result<List<Field>>> getFields(String type) async{
     try{

       String url='${GoogleSheet.baseUrl}?userType=fields&startRange=A6';
       var response= await http.get(Uri.parse(url));
       var data = jsonDecode(response.body);
       if (data['status'] == 'error') {
         return Result(null,userMessage: 'SpreadSheet Error: ${data['message']}', message:'${data['message']}' );
       }else{
         ///create [Field] list from the received data
         var fieldData = data['data'];
         List<Field> fields=[];
         fieldData.forEach((item){
           Field field;
           if(type==ReportType.AREA){
             if(item[0].toString().isNotEmpty && item[1].toString().isNotEmpty){
               field =  Field(item[0],item[1]);
               fields.add(field);
             }

           }else{
             if(item[3].toString().isNotEmpty && item[4].toString().isNotEmpty){
               field =  Field(item[3],item[4]);
               fields.add(field);
             }

           }

         });
         return Result(fields);
       }
     }catch(ex){
       return Result(null,success:false,userMessage: 'An error occurred while getting fields',message: ex.toString());
     }
  }

  @override
  Future<Result<Report>> removeReport(Report report)async {
    try{
      String? areaId,unitId;
      if(report.type==ReportType.AREA){
        areaId = (report as AreaReport).areaId!;
      }else{
        areaId = (report as UnitReport).areaId;
        unitId = report.unitId;
      }
       await _getReportsRef(report.type!,unitId: unitId, areaId: areaId).doc(report.id).delete();
      return Result(report);
    }catch(ex){
      return Result(null,success:false, userMessage: 'An error occurred while deleting this report',message: ex.toString());
    }
  }

  @override
  Future<Result<Report>> updateReport(Report report)async {
    try{
      String? areaId,unitId;
      if(report.type==ReportType.AREA){
        areaId = (report as AreaReport).areaId!;
      }else{
        areaId = (report as UnitReport).areaId;
        unitId = report.unitId;
      }
      await _getReportsRef(report.type!,unitId: unitId, areaId: areaId).doc(report.id).update(report.toMap());
      return Result(report);
    }catch(ex){
      return Result(null,success:false, userMessage: 'An error occurred while updating this report',message: ex.toString());
    }
  }

  @override
  Future<Result<Report>> addReport(Report report)async {
    try{
      String? areaId,unitId;
      if(report.type==ReportType.AREA){
        areaId = (report as AreaReport).areaId!;
      }else{
        areaId = (report as UnitReport).areaId;
        unitId = report.unitId;
      }

      DocumentReference ref = await _getReportsRef(report.type!,unitId: unitId, areaId: areaId).add(report);
      report.id=ref.id;
      return Result(report);
    }catch(ex,stack){
      print('err ${ex.toString()}\nstack ${stack.toString()}');
      return Result(null,success:false, userMessage: 'An error occurred while adding this report',message: ex.toString());
    }
  }

  @override
  Future<Result<Report>> getReferredDetails(Report report) async{
    try{
      ///get the creator info
      var result = await userFactory.getUser(report.creatorId!);
      if(result.success){
        report.creator=result.value!;
        return Result(report);
      }else{
        return Result(null,success: false,userMessage: 'Failed to get the Creator of this Report', message: result.message!);
      }
    }catch(ex){
      return Result(null,success:false, userMessage: 'An error occurred while getting the Creator of this report',message: ex.toString());
    }
  }


}