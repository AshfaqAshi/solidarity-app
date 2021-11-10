
import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/unit/unit_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/unit/unit.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/widgets/design_dialog.dart';

class UnitDetailsWindow extends StatelessWidget{
  late UnitBloc unitBloc;
  late BuildContext context;

  Widget build(BuildContext context){
    unitBloc = context.read<UnitBloc>();
    this.context = context;
    return Dialog(
      child: BlocConsumer<UnitBloc,UnitState>(
        builder: (context, state){
          Unit unit = unitBloc.selectedUnit!;
          if(state is GetUnitDetailsState){
            return LoadingWidget(message: 'Getting Unit details',);
          }

          if(state is GetUnitDetailsCompleteState) {
            if (state.result.success) {
              unit = state.result.value!;
            }
          }

              return SingleChildScrollView(
                child:DesignDialog(
                  title: unit.name,
                  actions: [
                    if(Helper.hasPrivilege(context.read<UserBloc>().loggedInUser!.designation, UserField.UNIT))
                      IconButton(onPressed: (){
                        Helper.navigate(context, Screens.ADD_UNIT,arguments: UnitArguments(unit));
                      }, icon: Icon(Icons.edit,color: Theme.of(context).colorScheme.onPrimary,))
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      areaRepBox('President', unit.president!.name!),
                      VerticalSpace(),
                      areaRepBox('Secretary', unit.secretary!.name!),
                      VerticalSpace(),
                      if(unit.jointSecretary!=null)
                        areaRepBox('Joint Secretary', unit.jointSecretary!.name!),
                    ],
                  ),
                ) ,
              );

          return Container();
        },

        listener: (context, state){
          if(state is GetUnitDetailsCompleteState){
            if(!state.result.success){
              Helper.showSnackBar(context, state.result.userMessage!,error: true);
            }
          }
        },
      ),
    );
  }

  Widget areaRepBox(String designation, String name){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(designation,style: Theme.of(context).textTheme.caption,),
        Text(name,style: Theme.of(context).textTheme.bodyText1,)
      ],
    );
  }
}