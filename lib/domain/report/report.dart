
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/report/field.dart';
import 'package:solidarity_app/domain/user/user.dart';

class Report{
  String? id;
  String? type;
  Timestamp? time;
  int? year;
  int? monthCode;
  String? monthName;
  String? creatorId;
  List<Field>? fields;

  ///Fields populated once referred details are loaded
  User? creator;
  Report({this.type,this.fields,this.year,this.monthCode,this.monthName,this.creatorId});

  Report.fromMap(DocumentSnapshot<Map<String,dynamic>> doc){
    this.id = doc.id;
    this.type=doc.data()!['type'];
    this.fields = getFieldsFromMap(doc.data()!['fields']);
    this.time = doc.data()!['time'];
    this.monthCode=doc.data()!['monthCode'];
    this.monthName = doc.data()!['monthName'];
    this.year = doc.data()!['year'];
    this.creatorId = doc.data()!['creatorId'];
  }

  toMap(){
    return {
      'type':this.type,
      'fields':fieldMap(),
      'year': this.year,
      'monthCode':this.monthCode,
      'monthName':this.monthName,
      'creatorId':this.creatorId,
      'time':FieldValue.serverTimestamp()
    };
  }


  List<Field> getFieldsFromMap(List<dynamic>? list){
    List<Field> _fields=[];
    if(list!=null){
      list.forEach((data) {
        _fields.add(Field.fromMap(data));
      });
    }
    return _fields;
  }

  List<dynamic> fieldMap(){
    List<dynamic> _list=[];
    if(this.fields!=null){
      this.fields!.forEach((field){
        _list.add(field.toMap());
      });
    }

    return _list;
  }

}

class ReportArguments<T extends Report>{
  bool isUpdate;
  T? report;
  ReportArguments({this.isUpdate=false,this.report});
}

class ReportType{
  static const String AREA='area';
  static const String UNIT='unit';
}