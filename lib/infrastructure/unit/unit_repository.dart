
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/factories.dart';
import 'package:solidarity_app/domain/unit/unit.dart';
import 'package:solidarity_app/domain/unit/unit_base.dart';
import 'package:solidarity_app/domain/unit/unit_factory.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';
import 'package:solidarity_app/infrastructure/core/general_repository.dart';

class UnitRepository implements UnitBase{



  CollectionReference<Unit> _getUnitCollection(String areaId){
    return GeneralRepository.getOrgDoc().
        collection(Collection.AREAS).doc(areaId).
    collection(Collection.UNITS).
    withConverter<Unit>(fromFirestore: (snap,options)=>Unit.fromMap(snap), toFirestore: (unit,options)=>unit.toMap());
  }

  DocumentReference<Unit> _getUnitDoc(String id,String areaId){
    return GeneralRepository.getOrgDoc().
    collection(Collection.AREAS).doc(areaId).
    collection(Collection.UNITS).
    withConverter<Unit>(fromFirestore: (snap,options)=>Unit.fromMap(snap), toFirestore: (unit,options)=>unit.toMap())
        .doc(id);
  }

  @override
  Future<Result<Unit>> addNewUnit(Unit unit)async {
    try{
      DocumentReference ref = await _getUnitCollection(unit.areaId).add(unit);
      unit.id = ref.id;
      return Result(unit);
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while adding new Unit',
          message: ex.toString());
    }
  }

  @override
  Future<Result<List<Unit>>> getUnits(String areaId)async {
    try{
      List<Unit> _units=[];
      QuerySnapshot<Unit> snap = await _getUnitCollection(areaId).where('areaId',isEqualTo: areaId).get();
      snap.docs.forEach((doc){
        _units.add(doc.data());
      });
      return Result(_units);
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while getting Unit information',
          message: ex.toString());
    }
  }

  @override
  Future<Result<Unit>> removeUnit(Unit unit) async{
    try{
      await _getUnitDoc(unit.id!,unit.areaId).delete();
      return Result(unit);
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while deleting Unit',
          message: ex.toString());
    }
  }

  @override
  Future<Result<Unit>> updateUnit(Unit unit) async{
    try{
      await _getUnitDoc(unit.id!,unit.areaId).update(unit.toMap());
      return Result(unit);
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while updating Unit',
          message: ex.toString());
    }
  }

  @override
  Future<Result<Unit>> getUnitDetails(Unit unit)async {
    try{
      Completer<Result<Unit>> completer = Completer();
      int docFetched=0;
      Map<String,User?> idMap={unit.presidentId:null,
        unit.secretaryId:null, unit.jointSecretaryId ?? '':null};

      Map<String,User?> retrievedUsers={};

      idMap.forEach((key, value)async {
        if(key.isEmpty){
          docFetched+=1;
        }else{
          var user = await Factories.userFactory.getUser(key);
          docFetched+=1;
          if(user.success){
            retrievedUsers.addAll({key:user.value});
          }
        }

        if(docFetched==idMap.length){
          ///All docs received
          retrievedUsers.forEach((key, value) {
            if(key==unit.presidentId){
              unit.president = value;
            }else if(key==unit.secretaryId){
              unit.secretary=value;
            }else{
              unit.jointSecretary=value;
            }
          });
          completer.complete(Result(unit));
        }
      });

      return completer.future;
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while getting Unit details',
          message: ex.toString());
    }
  }

  @override
  Future<Result<Unit>> getUnit(String unitId,String areaId)async {
    try{
      var unitSnap = await _getUnitDoc(unitId, areaId).get();
      if(unitSnap.exists){
        return Result(unitSnap.data());
      }else{
        return Result(null,success: false,userMessage: 'This Unit does not exist!');
      }
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while getting Unit details',
          message: ex.toString());
    }
  }

}