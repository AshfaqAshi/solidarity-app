import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/user/user.dart';

class Area{
  String? id;
  String name;
  String presidentId;
  String secretaryId;
  String? jointSecretaryId;

  ///Referenced Values
  User? president;
  User? secretary;
  User? jointSecretary;

  Area({required this.name, required this.presidentId, required this.secretaryId, this.jointSecretaryId});

  Area.fromMap(DocumentSnapshot<Map<String,dynamic>> doc):
        this.name = doc.data()!['name'],
        this.secretaryId=doc.data()!['secretaryId'],
        this.presidentId = doc.data()!['presidentId']{
    this.jointSecretaryId = doc.data()!['jointSecretaryId'];
        this.id = doc.id;
  }

  toMap(){
    return {
      'presidentId':this.presidentId,
      'secretaryId':this.secretaryId,
      'jointSecretaryId':this.jointSecretaryId,
      'name':this.name
    };
  }
}

class AreaArguments{
  Area area;
  AreaArguments(this.area);
}