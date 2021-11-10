
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/area/area_factory.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/factories.dart';
import 'package:solidarity_app/domain/unit/unit_factory.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';
import 'package:solidarity_app/domain/user/user_repository_base.dart';
import 'package:solidarity_app/domain/user/user_settings.dart';
import 'package:solidarity_app/infrastructure/core/general_repository.dart';

class UserRepository implements UserRepositoryBase{
  
  CollectionReference<User> _getUserCollection(){
    return GeneralRepository.getOrgDoc().
    collection(Collection.USERS).
        withConverter<User>(fromFirestore: (snap,options)=>User.fromMap(snap), toFirestore: (user,options)=>user.toMap());
  }

  DocumentReference<User> _getUserDoc(String id){
    return GeneralRepository.getOrgDoc().
    collection(Collection.USERS).
    withConverter<User>(fromFirestore: (snap,options)=>User.fromMap(snap), toFirestore: (user,options)=>user.toMap())
    .doc(id);
  }

  @override
  Future<Result<User>> createNewUser(User user)async{
    try{
        await _getUserCollection().doc(user.uid).set(user);
      return Result(user,);
    }catch(ex){
      return Result(null,success: false,userMessage: 'Failed to create or update user', message: ex.toString());
    }
  }

  @override
  Future<Result<User>> removeUser(User user) {
    // TODO: implement removeUser
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> getUser(String uid)async{
    try{
      Completer<Result<User>> completer = Completer();
      DocumentSnapshot<User> userSnap = await _getUserDoc(uid).get();
      if(userSnap.exists){
        ///user exists!
        User user = userSnap.data()!;
        if(user.unitId==null|| user.areaId==null){
          ///Get user's area and unit details
          return Result(user);
        }else{
          bool unitFetched=false;
          bool areaFetched=false;
          Factories.unitFactory.getUnit(user.unitId!,user.areaId!).then((result){
            unitFetched=true;
            if(result.success){
              user.unit = result.value;
            }
            if(areaFetched){
              completer.complete(Result(user));
            }
          });


          Factories.areaFactory.getArea(user.areaId!).then((result){
            areaFetched=true;
            if(result.success){
              user.area = result.value;
            }
            if(unitFetched){
              completer.complete(Result(user));
            }
          });
          return completer.future;
        }

      }else{
        ///this user does not exist! oops!
        return Result(null,errorCode: ErrorCodes.NO_USER, success: false, userMessage: 'This user does not exist!');
      }
    }catch(ex,stack){
      print('error ${ex.toString()}');
      print('stack ${stack.toString()}');
      return Result(null,success: false,userMessage: 'An error occurred while getting user', message: ex.toString());
    }
  }

  @override
  Future<Result<List<User>>> getAllUsers()async {
    try{
      QuerySnapshot<User> userSnap = await _getUserCollection().get();
      List<User> _users=[];

      userSnap.docs.forEach((doc){
        _users.add(doc.data());
      });
      return Result(_users);
    }catch(ex){
      return Result(null,success: false,userMessage: 'An error occurred while getting users', message: ex.toString());
    }
  }

  @override
  Future<Result<User>> saveUser(User user)async {
    try{
      await _getUserDoc(user.uid!).update(user.toMap());
      return Result(user);
    }catch(ex){
      return Result(null,success: false,userMessage: 'An error occurred while updating user', message: ex.toString());
    }
  }

  @override
  Future<Result<UserSettings>> getUserSettings() {
    // TODO: implement getUserSettings
    throw UnimplementedError();
  }

  @override
  Future<Result<UserSettings>> saveUserSettings(UserSettings settings) {
    // TODO: implement saveUserSettings
    throw UnimplementedError();
  }

}

