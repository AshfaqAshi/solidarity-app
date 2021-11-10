
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/unit/unit.dart';

class User{
  String? uid;
  String? name;
  String? phone;
  String? field;
  String? unitId;
  String? areaId;
  String designation;

  ///Fields populated once referred details are loaded
  Unit? unit;
  Area? area;
  User( {this.field,required this.designation, this.name,this.phone});

  User.fromMap(DocumentSnapshot<Map<String,dynamic>> doc):
      this.name=doc.data()!['name'],
        this.phone=doc.data()!['phone'],
        this.field=doc.data()!['field'],
        this.designation = doc.data()!['designation'],
   this.uid=doc.data()!['uid'],
  this.unitId = doc.data()!['unitId'],
  this.areaId = doc.data()!['areaId'];

  toMap(){
    return {
      'name':this.name,
      'uid':this.uid,
      'field':this.field,
      'designation':this.designation,
      'phone':this.phone,
      'areaId':this.areaId,
      'unitId':this.unitId
    };
  }
}

class UserField{
 static const String UNIT='unit';
 static const String AREA='area';
}

class UserDesignation{
  static const String AREA_PRESIDENT='area_president';
  static const String UNIT_PRESIDENT='unit_president';
  static const String AREA_SECRETARY='area_secretary';
  static const String UNIT_SECRETARY='unit_secretary';
  static const String ADMIN='admin';
  static const String AREA_MEMBER='area_member';
  static const String UNIT_MEMBER='unit_member';
  static const String AREA_JOINT_SECRETARY='area_joint_secretary';
  static const String UNIT_JOINT_SECRETARY='unit_joint_secretary';
}