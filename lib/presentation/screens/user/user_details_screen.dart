import 'package:flutter/material.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/scaffold_base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/dialogs/designation_selector_window.dart';

class UserDetailsScreen extends ScaffoldBase{
  _ScreenState createState()=>_ScreenState();
}

class _ScreenState extends ScaffoldBaseState<UserDetailsScreen>{

  late UserBloc bloc;

  @override
  bool showBg()=>true;
  @override
  void initState(){
    super.initState();
    bloc = context.read<UserBloc>();
    bloc.add(GetUserEvent(bloc.selectedUser!.uid!));
  }
  @override
  String title() {
    return bloc.selectedUser!.name!;
  }



  @override
  Widget body() {
    return BlocConsumer<UserBloc,UserState>(
      builder: (context,state){
        User? user;
        if(state is GetUserState || state is SaveUserState){
          String message = 'Getting user details';
          if(state is SaveUserState){
            message = 'Saving changes';
          }
          return LoadingWidget(message: 'Getting user details',);
        }

        if(state is GetUserStateComplete){
          if(state.result.success){
            user = state.result.value!;
          }else{
            return Center(child: ErrorText(state.result.userMessage!),);
          }
        }

        if(state is SaveUserCompleteState){
          if(state.result.success){
            user = state.result.value!;
          }else{
            return Center(child: ErrorText(state.result.userMessage!),);
          }
        }



        if(user!=null){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Text(user.name??'Name not given', style: Theme.of(context).textTheme.headline4,),
                VerticalSpace(),
                if(user.phone!=null)
                Text(user.phone!,style: Theme.of(context).textTheme.headline5,),
                if(user.phone!=null)
                VerticalSpace(),
                UserRoleWidget(user),
                VerticalSpace(),
                if(user.area!=null)
                  LightText('Area: ${user.area!.name}',fontSize: 15,),
                if(user.unit!=null)
                  LightText('Unit: ${user.unit!.name}',fontSize: 15,),
              ],
            );

        }

        return Container();
      },

      listener: (context,state){
        if(state is SaveUserCompleteState){
          if(state.result.success){
            Helper.showSnackBar(context, 'Successfully saved');
            bloc.setSelectedUser(state.result.value!);
          }else{
            Helper.showSnackBar(context, state.result.userMessage!,error: true);
          }
        }
      },
    );
  }



}