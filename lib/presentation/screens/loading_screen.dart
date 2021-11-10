import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/core/local_service.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/unit/unit.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/screens/home_screen.dart';
import 'package:solidarity_app/presentation/screens/login_screen.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/widgets/loaders/loading_widget.dart';

class LoadingScreen extends StatefulWidget{
  _loadingScreenState createState()=>_loadingScreenState();
}
class _loadingScreenState extends State<LoadingScreen>{

  late AuthBloc authBloc;
  late UserBloc userBloc;

  void initState(){
    super.initState();
    authBloc = context.read<AuthBloc>();
    userBloc = context.read<UserBloc>();
    userBloc.add(GetLoggedInUserEvent());
    //get theme
    context.read<LocalService>().setUserTheme(context);
  }

  _navigateToAreaDetails(Area area){
    context.read<AreaBloc>().setSelectedArea(area);
    Helper.navigate(context, Screens.AREA_DETAILS,
        pushReplace: true);
  }
  Widget build(BuildContext context){

    return  SafeArea(
      child: Material(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              BlocConsumer<UserBloc,UserState>(
                builder: (context, state){
                  if(state is GetLoggedInUserState || state is SaveUserState ){
                    String message = 'Hold on';
                    if(state is SaveUserState){
                      message = 'Updating your info';
                    }
                    return LoadingWidget(message: message,);
                  }

                  return Container();
                },

                listener: (context, state)async{
                  if(state is GetLoggedInUserStateComplete){
                   // print('${state.result.userMessage}');
                    if(state.result.value==null){
                      if(state.result.userMessage!=null){
                        Helper.showSnackBar(context, state.result.userMessage!,error: true);
                      }
                      ///user not logged in
                      Helper.navigate(context, Screens.LOGIN,pushReplace: true);
                    }else{
                      //Helper.navigate(context, Screens.HOME,pushReplace: true);
                      ///Get user designation type and navigate accordingly
                      if(state.result.value!.designation!=UserDesignation.ADMIN){
                        if(state.result.value!.areaId==null || state.result.value!.unitId==null){
                          ///user has not configured his area and unit. so navigate him to
                          ///the selector screen
                         Helper.navigate(context, Screens.AREA_UNIT_SELECTOR,pushReplace: true);

                        }else{
                          _navigateToAreaDetails(state.result.value!.area!);
                        }
                      }else{
                        Helper.navigate(context, Screens.AREA_LIST,pushReplace: true);
                      }

                    }
                  }else if(state is SaveUserCompleteState){
                    if(state.result.success){
                      userBloc.setLoggedInUser(state.result.value!);
                      _navigateToAreaDetails(state.result.value!.area!);
                    }else{
                      Helper.showSnackBar(context, state.result.userMessage!,error: true);
                      Helper.navigate(context, Screens.LOGIN,pushReplace: true);
                    }
                  }
                },
              )
            ],
          ),
      ),
    );
  }
}