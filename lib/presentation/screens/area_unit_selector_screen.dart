import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/unit/unit_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/unit/unit.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/scaffold_base.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';


class AreaUnitSelectorScreen extends ScaffoldBase{
_ScreenState createState()=>_ScreenState();
}

class _ScreenState extends ScaffoldBaseState<AreaUnitSelectorScreen>{

  String title()=>_isAreaSelection?'Choose an Area':'Choose a Unit';
  @override
  bool needScrollView()=>false;

  Area? _selectedArea;
  Unit? _selectedUnit;

  late UnitBloc unitBloc;
  late AreaBloc areaBloc;
  late UserBloc userBloc;

  bool _isAreaSelection=true;

  void initState(){
    super.initState();
    unitBloc = context.read<UnitBloc>();
    areaBloc = context.read<AreaBloc>();
    userBloc = context.read<UserBloc>();

    areaBloc.add(GetAreasEvent());
  }

  Widget body(){
    return BlocConsumer<UserBloc,UserState>(
      builder: (context, state){
        if(state is SaveUserState){
          return LoadingWidget(
            message: 'Updating User info',
          );
        }
        if(_isAreaSelection){
          return areaList();
        }else{
          return unitList();
        }
      },

      listener: (context,state){
        if(state is SaveUserCompleteState){
          if(state.result.success){
            userBloc.setLoggedInUser(state.result.value!);
            Helper.navigate(context, Screens.AREA_DETAILS,
                pushReplace: true);
          }else{
            Helper.showSnackBar(context, state.result.userMessage!,error: true);
            Helper.navigate(context, Screens.LOGIN,pushReplace: true);
          }
        }
      },
    );
  }

  Widget areaList(){
    return BlocConsumer<AreaBloc,AreaState>(
      builder: (context,state){
        if(state is GetAreasState){
          return LoadingWidget(
            message: 'Getting Area list',
          );
        }

        return Column(
          children: [
            Text('Choose an Area',style: Theme.of(context).textTheme.headline5,),
            VerticalSpace(),
            Expanded(child: ListView.builder(
              itemCount: areaBloc.areas.length,
              itemBuilder: (context, index){
                Area area = areaBloc.areas[index];
                return itemBox(area.name,
                    onPress: (){
                      setState(() {
                        areaBloc.setSelectedArea(area);
                        unitBloc.add(GetUnitsEvent(area.id!));
                        _selectedArea=area;
                        _isAreaSelection=false;
                      });
                    });
              },
            ))
          ],
        );
      },

      listener: (context,state){
        if(state is GetAreasCompleteState){
          if(!state.areas.success){
            Helper.showSnackBar(context, state.areas.userMessage!);
          }
        }
      },
    );
  }

  Widget unitList(){
    return BlocConsumer<UnitBloc,UnitState>(
      builder: (context,state){
        if(state is GetUnitsState){
          return LoadingWidget(
            message: 'Getting Unit list',
          );
        }

        return Column(
          children: [
            Text('Area: ${_selectedArea!.name}'),
            Text('Choose a Unit',style: Theme.of(context).textTheme.headline5,),
            VerticalSpace(),
            Expanded(
              child: ListView.builder(
                itemCount: unitBloc.units.length,
                itemBuilder: (context, index){
                  Unit unit = unitBloc.units[index];
                  return itemBox(unit.name,
                      onPress: (){
                        _selectedUnit = unit;
                        if(userBloc.loggedInUser!=null){
                          User user = userBloc.loggedInUser!;
                          user.areaId=_selectedArea!.id;
                          user.area = _selectedArea;
                          user.unit = unit;
                          user.unitId = unit.id;
                          userBloc.add(SaveUserEvent(user));
                        }else{
                          Helper.navigate(context, Screens.LOGIN,pushReplace: true);
                        }
                      });
                },
              ),
            )
          ],
        );
      },

      listener: (context,state){
        if(state is GetUnitsCompleteState){
          if(!state.result.success){
            Helper.showSnackBar(context, state.result.userMessage!,error: true);
          }
        }
      },
    );
  }

  Widget itemBox(String title,{onPress}){
    return OutlinedButtonTheme(
      data: OutlinedButtonThemeData(
          style: ButtonStyle(
              alignment: Alignment.centerLeft
          )
      ),
      child: OutlinedButton(
        onPressed:onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: Theme.of(context).textTheme.bodyText1,),
            //Text(Helper.getUserDesignation(user.designation), style: Theme.of(context).textTheme.caption,)
          ],
        ),
      ),
    );
  }
}