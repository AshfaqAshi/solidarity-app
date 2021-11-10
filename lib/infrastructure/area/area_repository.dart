
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/area/area_base.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/factories.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';
import 'package:solidarity_app/infrastructure/core/general_repository.dart';

class AreaRepository implements AreaBase{

  CollectionReference<Area> _getAreaCollection(){
    return GeneralRepository.getOrgDoc().
    collection(Collection.AREAS).
    withConverter<Area>(fromFirestore: (snap,options)=>Area.fromMap(snap), toFirestore: (area,options)=>area.toMap());
  }

  DocumentReference<Area> _getAreaDoc(String id){
    return GeneralRepository.getOrgDoc().
    collection(Collection.AREAS).
    withConverter<Area>(fromFirestore: (snap,options)=>Area.fromMap(snap), toFirestore: (area,options)=>area.toMap())
        .doc(id);
  }

  @override
  Future<Result<Area>> addNewArea(Area area)async {
    try{
      DocumentReference ref = await _getAreaCollection().add(area);
      area.id = ref.id;
      return Result(area);
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while adding new Area',
      message: ex.toString());
    }
  }

  @override
  Future<Result<List<Area>>> getAreas()async {
    try{
      List<Area> _areas=[];
      QuerySnapshot<Area> snap = await _getAreaCollection().get();
      snap.docs.forEach((doc){
        _areas.add(doc.data());
      });

      return Result(_areas);
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while getting Area information',
          message: ex.toString());
    }
  }

  @override
  Future<Result<Area>> removeArea(Area area)async {
    try{
      await _getAreaDoc(area.id!).delete();
      return Result(area);
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while deleting Area',
          message: ex.toString());
    }
  }

  @override
  Future<Result<Area>> updateArea(Area area)async {
    try{
      await _getAreaDoc(area.id!).update(area.toMap());
      return Result(area);
    }catch(ex,stack){
      print('error ${ex.toString()}');
      print('stack ${stack.toString()}');
      return Result(null,success: false, userMessage: 'An error occurred while updating Area',
          message: ex.toString());
    }
  }

  @override
  Future<Result<Area>> getAreaDetails(Area area) async{
    try{
      Completer<Result<Area>> completer = Completer();
      int docFetched=0;
      Map<String,User?> idMap={area.presidentId:null,
        area.secretaryId:null, area.jointSecretaryId ?? '':null};

      Map<String,User?> retrievedUsers={};

      idMap.forEach((key, value)async {
        if(key.isEmpty){
          docFetched+=1;
        }else{
        //  print('getting data for $key');
          var user = await Factories.userFactory.getUser(key);
        //  print('received data for ${key}');
          docFetched+=1;
          if(user.success){
            retrievedUsers.addAll({key:user.value});
          }
        }

        if(docFetched==idMap.length){
          ///All docs received
          retrievedUsers.forEach((key, value) {
            if(key==area.presidentId){
              area.president = value;
            }else if(key==area.secretaryId){
              area.secretary=value;
            }else{
              area.jointSecretary=value;
            }
          });
          completer.complete(Result(area));
        }
      });

      return completer.future;
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while updating Area',
          message: ex.toString());
    }
  }

  @override
  Future<Result<Area>> getArea(String areaId)async {
    try{
      var areaSnap = await _getAreaDoc(areaId).get();
      if(areaSnap.exists){
        return Result(areaSnap.data());
      }else{
        return Result(null,success: false,userMessage: 'This Area does not exist!');
      }
    }catch(ex){
      return Result(null,success: false, userMessage: 'An error occurred while getting Area details',
          message: ex.toString());
    }
  }

}