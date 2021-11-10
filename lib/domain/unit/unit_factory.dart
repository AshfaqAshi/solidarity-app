
import 'package:flutter/animation.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/unit/unit.dart';
import 'package:solidarity_app/domain/unit/unit_base.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';
import 'package:solidarity_app/infrastructure/unit/unit_repository.dart';

import '../factories.dart';

class UnitFactory implements UnitBase{

  UnitFactory._();

  static UnitFactory get instance {
    if(_instance==null) _instance = UnitFactory._();
    return _instance!;
  }

  static UnitFactory? _instance;

  UnitRepository repo = UnitRepository();

  List<Unit> _units = [];
  Unit? _selectedUnit;

  Unit? get selectedUnit=>_selectedUnit;
  List<Unit> get units =>_units;


  bool _hasUnitPrivilege(){
      if(Factories.userFactory.loggedInUser!.designation!=UserDesignation.UNIT_MEMBER){
        return true;
      }

    return false;
  }

  void setSelectedUnit(Unit unit){
    _selectedUnit = unit;
  }

  @override
  Future<Result<Unit>> addNewUnit(Unit unit) async{
    if(_hasUnitPrivilege()){
      var result = await repo.addNewUnit(unit);
      if(result.success){
        _units.insert(0,unit);
      }
      return result;
    }else{
      return Result(null,success: false,userMessage: 'You do not have permission to add a Unit');
    }
  }

  @override
  Future<Result<List<Unit>>> getUnits(String areaId)async {
    var result = await repo.getUnits(areaId);
    if(result.success){
      _units = List.from(result.value!);
    }
    return result;
  }

  @override
  Future<Result<Unit>> removeUnit(Unit unit)async {
   if(_hasUnitPrivilege()){
     var result = await repo.removeUnit(unit);
     if(result.success){
       //delete from local list
       int index = _units.indexWhere((data)=>data.id==unit.id);
       if(index>=0){
         _units.removeAt(index);
       }
     }
     return result;
   }else{
     return Result(null,success: false,userMessage: 'You do not have permission to remove a Unit');
   }
  }

  @override
  Future<Result<Unit>> updateUnit(Unit unit) async{
    if(_hasUnitPrivilege()){
      var result = await repo.updateUnit(unit);
      if(result.success){
        //delete from local list
        int index = _units.indexWhere((data)=>data.id==unit.id);
        if(index>=0){
          _units[index]=unit;
        }
        //updated [selectedUnit]
        _selectedUnit = result.value!;
      }
      return result;
    }else{
      return Result(null,success: false,userMessage: 'You do not have permission to edit a Unit');
    }
  }

  @override
  Future<Result<Unit>> getUnitDetails(Unit unit)async {
    return await repo.getUnitDetails(unit);
  }

  @override
  Future<Result<Unit>> getUnit(String unitId, String areaId) async{
    return await repo.getUnit(unitId,areaId);
  }

}