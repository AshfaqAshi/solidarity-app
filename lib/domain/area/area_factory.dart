
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/area/area_base.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/factories.dart';
import 'package:solidarity_app/domain/report/area_report.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';
import 'package:solidarity_app/infrastructure/area/area_repository.dart';

class AreaFactory implements AreaBase{

  AreaFactory._();

  static AreaFactory get instance {
    if(_instance==null) _instance = AreaFactory._();
    return _instance!;
  }

  static AreaFactory? _instance;

  AreaRepository repo = AreaRepository();


  Area?  _selectedArea;

  Area? get selectedArea=>_selectedArea;

  List<Area> _areas = [];
  List<Area> get areas =>_areas;

  void setSelectedArea(Area area){
    _selectedArea = area;
  }

  bool _hasAreaPrivilege(){
    if(Factories.userFactory.loggedInUser!.field==UserField.AREA ||
        Factories.userFactory.loggedInUser!.designation==UserDesignation.ADMIN){
      if(Factories.userFactory.loggedInUser!.designation!=UserDesignation.AREA_MEMBER){
        return true;
      }
    }
    return false;
  }

  @override
  Future<Result<Area>> addNewArea(Area area)async {
    //first check if this user has the permission to do it
    if(_hasAreaPrivilege()){
      var result = await repo.addNewArea(area);
      if(result.success){
        _areas.add(area);
      }
      return result;
    }else{
      return Result(null,userMessage: 'You do not have permission to add new Area',success: false);
    }
  }

  @override
  Future<Result<List<Area>>> getAreas()async {
    var result = await repo.getAreas();
    if(result.success){
      _areas = List.from(result.value!);
    }
    return result;
  }

  @override
  Future<Result<Area>> removeArea(Area area) async{
    //first check if this user has the permission to do it
    if(_hasAreaPrivilege()){
      var result = await repo.removeArea(area);
      if(result.success){
        //delete from local list
        int index = _areas.indexWhere((data)=>data.id==area.id);
        if(index>=0){
          _areas.removeAt(index);
        }
      }
      return result;
    }else{
      return Result(null,userMessage: 'You do not have permission to remove an Area',success: false);
    }
  }

  @override
  Future<Result<Area>> updateArea(Area area)async {
    //first check if this user has the permission to do it
    if(_hasAreaPrivilege()){
      var result = await repo.updateArea(area);
      if(result.success){
        //delete from local list
        int index = _areas.indexWhere((data)=>data.id==area.id);
        if(index>=0){
          _areas[index]=result.value!;
        }
        ///also update the [selectedArea] with new values
        _selectedArea = result.value;
      }
      return result;
    }else{
      return Result(null,userMessage: 'You do not have permission to edit an Area',success: false);
    }
  }

  @override
  Future<Result<Area>> getAreaDetails(Area area) async{
    return await repo.getAreaDetails(area);
  }

  @override
  Future<Result<Area>> getArea(String areaId)async {
    return await repo.getArea(areaId);
  }

}