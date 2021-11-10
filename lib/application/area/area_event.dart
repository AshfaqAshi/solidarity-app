part of 'area_bloc.dart';

@immutable
abstract class AreaEvent {}

class AddAreaEvent extends AreaEvent{
  final Area area;
  AddAreaEvent(this.area);
}

class UpdateAreaEvent extends AreaEvent{
  final Area area;
  UpdateAreaEvent(this.area);
}

class RemoveAreaEvent extends AreaEvent{
  final Area area;
  RemoveAreaEvent(this.area);
}

class GetAreasEvent extends AreaEvent{}

class GetAreaDetailsEvent extends AreaEvent{
  final Area area;
  GetAreaDetailsEvent(this.area);
}
