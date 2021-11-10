
import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/widgets/design_dialog.dart';

class AreaDetailsWindow extends StatelessWidget{
  late AreaBloc areaBloc;
  late BuildContext context;

  Widget build(BuildContext context){
    areaBloc = context.read<AreaBloc>();
    this.context = context;
    return Dialog(
      child: BlocConsumer<AreaBloc,AreaState>(
            builder: (context, state){
               Area area = areaBloc.selectedArea!;
              if(state is GetAreaDetailsState){
                return LoadingWidget(message: 'Getting Area details',);
              }

              if(state is GetAreaDetailsCompleteState) {
                if (state.result.success) {
                  area = state.result.value!;
                }else{
                  return Center(child: ErrorText(state.result.userMessage!));
                }
              }

                  return SingleChildScrollView(
                    child: DesignDialog(
                      title: area.name,
                      actions: [
                        if(Helper.hasPrivilege(context.read<UserBloc>().loggedInUser!.designation, UserField.AREA))
                          IconButton(onPressed: (){
                            Helper.navigate(context, Screens.ADD_AREA,arguments: AreaArguments(area));
                          }, icon: Icon(Icons.edit,color: Theme.of(context).colorScheme.onPrimary,))
                      ],
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            areaRepBox('President', area.president!.name!),
                            VerticalSpace(),
                            areaRepBox('Secretary', area.secretary!.name!),
                            VerticalSpace(),
                            if(area.jointSecretary!=null)
                              areaRepBox('Joint Secretary', area.jointSecretary!.name!),
                          ],
                        ),
                    ) ,
                  );


              return Container();
            },

            listener: (context, state){
              if(state is GetAreaDetailsCompleteState){
                if(!state.result.success){
                  Helper.showSnackBar(context, state.result.userMessage!,error: true);
                }
              }
            },
          )
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