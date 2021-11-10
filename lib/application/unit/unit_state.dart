part of 'unit_bloc.dart';

@immutable
abstract class UnitState {}

class UnitInitial extends UnitState {}

class GetUnitsState extends UnitState{}
class GetUnitsCompleteState extends UnitState{
  final Result<List<Unit>> result;
  GetUnitsCompleteState(this.result);
}

class AddUnitState extends UnitState{}

class AddUnitCompleteState extends UnitState{
  final Result<Unit> unit;
  AddUnitCompleteState(this.unit);
}

class RemoveUnitState extends UnitState{}

class RemoveUnitCompleteState extends UnitState{
  final Result<Unit> unit;
  RemoveUnitCompleteState(this.unit);
}

class UpdateUnitState extends UnitState{}

class UpdateUnitCompleteState extends UnitState{
  final Result<Unit> unit;
  UpdateUnitCompleteState(this.unit);
}

class GetUnitDetailsState extends UnitState{}

class GetUnitDetailsCompleteState extends UnitState{
  final Result<Unit> result;
  GetUnitDetailsCompleteState(this.result);
}