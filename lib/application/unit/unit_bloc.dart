import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/unit/unit.dart';
import 'package:solidarity_app/domain/unit/unit_factory.dart';

part 'unit_event.dart';
part 'unit_state.dart';

class UnitBloc extends Bloc<UnitEvent, UnitState> {
  UnitBloc() : super(UnitInitial());

  UnitFactory unitFactory = UnitFactory.instance;

  Unit? get selectedUnit=>unitFactory.selectedUnit;

  List<Unit> get units => unitFactory.units;

  @override
  Stream<UnitState> mapEventToState(
    UnitEvent event,
  ) async* {
    if(event is GetUnitsEvent){
      yield GetUnitsState();
      var result = await unitFactory.getUnits(event.areaId);
      yield GetUnitsCompleteState(result);
    }else if(event is AddUnitEvent){
      yield AddUnitState();
      var result = await unitFactory.addNewUnit(event.unit);
      yield AddUnitCompleteState(result);
    }else if(event is RemoveUnitEvent){
      yield RemoveUnitState();
      var result = await unitFactory.removeUnit(event.unit);
      yield RemoveUnitCompleteState(result);
    }else if(event is UpdateUnitEvent){
      yield UpdateUnitState();
      var result = await unitFactory.updateUnit(event.unit);
      yield UpdateUnitCompleteState(result);
    }else if(event is GetUnitDetailsEvent){
      yield GetUnitDetailsState();
      var result = await unitFactory.getUnitDetails(event.unit);
      yield GetUnitDetailsCompleteState(result);
    }
  }

  void setSelectedUnit(Unit unit){
    unitFactory.setSelectedUnit(unit);
  }
}
