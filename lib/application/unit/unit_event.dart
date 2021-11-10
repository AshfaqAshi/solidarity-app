part of 'unit_bloc.dart';

@immutable
abstract class UnitEvent {}

class AddUnitEvent extends UnitEvent{
  final Unit unit;
  AddUnitEvent(this.unit);
}

class GetUnitsEvent extends UnitEvent{
  final String areaId;
  GetUnitsEvent(this.areaId);
}

class RemoveUnitEvent extends UnitEvent{
  final Unit unit;
  RemoveUnitEvent(this.unit);
}

class UpdateUnitEvent extends UnitEvent{
  final Unit unit;
  UpdateUnitEvent(this.unit);
}

class GetUnitDetailsEvent extends UnitEvent{
  final Unit unit;
  GetUnitDetailsEvent(this.unit);
}