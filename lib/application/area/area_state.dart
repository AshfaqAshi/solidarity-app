part of 'area_bloc.dart';

@immutable
abstract class AreaState {}

class AreaInitial extends AreaState {}

class GetAreasState extends AreaState{}

class GetAreasCompleteState extends AreaState{
  final Result<List<Area>> areas;
  GetAreasCompleteState(this.areas);
}

class AddAreaState extends AreaState{}

class AddAreaCompleteState extends AreaState{
  final Result<Area> result;
  AddAreaCompleteState(this.result);
}

class RemoveAreaState extends AreaState{}

class RemoveAreaCompleteState extends AreaState{
  final Result<Area> result;
  RemoveAreaCompleteState(this.result);
}

class UpdateAreaState extends AreaState{}

class UpdateAreaCompleteState extends AreaState{
  final Result<Area> result;
  UpdateAreaCompleteState(this.result);
}

class GetAreaDetailsState extends AreaState{}

class GetAreaDetailsCompleteState extends AreaState{
  final Result<Area> result;
  GetAreaDetailsCompleteState(this.result);
}