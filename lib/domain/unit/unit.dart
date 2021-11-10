import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/user/user.dart';

class Unit{
  String? id;
  String name;
  String areaId;
  String presidentId;
  String secretaryId;
  String? jointSecretaryId;

  ///Referenced Values
  User? president;
  User? secretary;
  User? jointSecretary;

  Unit({required this.name, required this.presidentId, required this.secretaryId, required this.areaId,this.jointSecretaryId});

  Unit.fromMap(DocumentSnapshot<Map<String,dynamic>> doc):
        this.name = doc.data()!['name'],
        this.secretaryId=doc.data()!['secretaryId'],

        this.presidentId = doc.data()!['presidentId'],
        this.areaId = doc.data()!['areaId']{
    this.id = doc.id;
    this.jointSecretaryId =doc.data()!['jointSecretaryId'];
  }

  toMap(){
    return {
      'presidentId':this.presidentId,
      'secretaryId':this.secretaryId,
      'jointSecretaryId':this.jointSecretaryId,
      'areaId':this.areaId,
      'name':this.name
    };
  }
}

class UnitArguments{
  Unit unit;
  UnitArguments(this.unit);
}