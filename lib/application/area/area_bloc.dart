import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/area/area_factory.dart';
import 'package:solidarity_app/domain/core/result.dart';

part 'area_event.dart';
part 'area_state.dart';

class AreaBloc extends Bloc<AreaEvent, AreaState> {
  AreaBloc() : super(AreaInitial());

  AreaFactory factory = AreaFactory.instance;

  Area? get selectedArea=>factory.selectedArea;
  List<Area> get areas => factory.areas;



  @override
  Stream<AreaState> mapEventToState(
    AreaEvent event,
  ) async* {

    if(event is GetAreasEvent){
      yield GetAreasState();
      var result = await factory.getAreas();
      yield GetAreasCompleteState(result);
    }else if(event is AddAreaEvent){
      yield AddAreaState();
      var result = await factory.addNewArea(event.area);
      yield AddAreaCompleteState(result);
    }else if(event is RemoveAreaEvent){
      yield RemoveAreaState();
      var result = await factory.removeArea(event.area);
      yield RemoveAreaCompleteState(result);
    }else if(event is UpdateAreaEvent){
      yield UpdateAreaState();
      var result = await factory.updateArea(event.area);
      yield UpdateAreaCompleteState(result);
    }else if(event is GetAreaDetailsEvent){
      yield GetAreaDetailsState();
      var result = await factory.getAreaDetails(event.area);
      yield GetAreaDetailsCompleteState(result);
    }
    
  }

  void setSelectedArea(Area area){
    factory.setSelectedArea(area);
  }
}
