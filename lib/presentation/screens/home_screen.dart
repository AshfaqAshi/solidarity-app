import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/report/report_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/scaffold_base.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/widgets/loaders/loading_widget.dart';
import 'package:solidarity_app/presentation/widgets/welcome_card.dart';

class HomeScreen extends ScaffoldBase{
  _homeScreenState createState()=>_homeScreenState();
}

class _homeScreenState extends ScaffoldBaseState<HomeScreen> with SingleTickerProviderStateMixin{
  late UserBloc userBloc;
  late AreaBloc areaBloc;

  int selectedMonth=0;

  List<String> titles=[];

  void initState(){
    super.initState();
    userBloc = context.read<UserBloc>();
    areaBloc = context.read<AreaBloc>();
    areaBloc.add(GetAreasEvent());
  }

  @override
  Widget body() {
   return Column(
     mainAxisAlignment: MainAxisAlignment.end,
     children: [
       Text('HEyyyy!!' )
     ],
   );
  }

  @override
  String title() {
    // TODO: implement title
    return 'My title';
  }

  /*Widget build(BuildContext context){
    return Scaffold(
      body:  Padding(
        padding: const EdgeInsets.all(Constants.SCAFFOLD_PADDING),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      ),
    );
  }*/
}