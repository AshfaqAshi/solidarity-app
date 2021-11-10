import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/report/report_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/report/field.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/menu_item.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/widgets/loaders/loading_widget.dart';

class AreaList extends StatefulWidget{
  _ListState createState()=>_ListState();
}

class _ListState extends State<AreaList> with SingleTickerProviderStateMixin{
  late UserBloc userBloc;
  late AreaBloc areaBloc;

  int selectedMonth=0;

  List<String> titles=[];



  _getLastMonthReportsOfUnits(){
    areaBloc.areas.forEach((area){
      DateTime dateTime = DateTime.now();
      DateTime lastMonth = DateTime(dateTime.year,dateTime.month-1,dateTime.day);
      context.read<ReportBloc>().add(GetReportForMonthEvent(ReportType.AREA, lastMonth.year,
          lastMonth.month,areaId: area.id));
    });
  }


  void initState(){
    super.initState();
    userBloc = context.read<UserBloc>();
    areaBloc = context.read<AreaBloc>();

    areaBloc.add(GetAreasEvent());

  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Area List'),
      actions: [
        MenuPopUpButton()
      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Helper.navigate(context, Screens.ADD_AREA);
        },
        child: Icon(Icons.add),
      ),
      body:  Padding(
        padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: BlocConsumer<AreaBloc,AreaState>(
                builder: (context, state){
                  if(state is GetAreasState){
                    return LoadingWidget();
                  }

                  if(areaBloc.areas.isEmpty){
                    return Center(
                      child: Text('No areas added!',style: Theme.of(context).textTheme.subtitle2,),
                    );
                  }
                  return ListView(
                      children: areaBloc.areas.map((area){

                        return BlocBuilder<ReportBloc,ReportState>(
                          buildWhen: (previous, current){
                            if(current is GetReportForMonthCompleteState ){
                              if(current.result.success){
                                if(current.type==ReportType.AREA && current.areaId==area.id){
                                  return true;
                                }
                              }else{
                                ///in case no report is found, it returns error
                                ///with
                                ///error code NO_DATA
                                if(current.result.errorCode==ErrorCodes.NO_DATA){
                                  if(current.type==ReportType.AREA && current.areaId==area.id){
                                    return true;
                                  }
                                }
                              }

                            }else if(current is GetReportForMonthState){
                              if(current.type==ReportType.AREA && current.areaId==area.id){
                                return true;
                              }
                            }
                            return false;
                          },
                          builder: (context,state){
                            Report? report;
                            bool isLoading=false;
                            bool hasError=false;
                            if(state is GetReportForMonthState){
                              isLoading=true;
                            }else if(state is GetReportForMonthCompleteState){
                              isLoading=false;
                              if(state.result.success){
                                report = state.result.value!;
                              }else{
                                if(state.result.errorCode!=ErrorCodes.NO_DATA){
                                  hasError=true;
                                }
                              }
                            }
                            return DesignTile(
                              onTap: (){
                                areaBloc.setSelectedArea(area);
                                Helper.navigate(context, Screens.AREA_DETAILS);
                              },
                              title: area.name,
                              content: Helper.getReportContentAsString(hasError, isLoading, report,
                              max: 100),
                            );
                          },
                        );
                      }).toList()
                  );
                },

                listener: (context, state){
                  if(state is AddAreaCompleteState){
                    if(state.result.success){
                      ///New Area added.
                      ///So update the UI with last month record
                      _getLastMonthReportsOfUnits();
                    }
                  }else if(state is UpdateAreaCompleteState){
                    if(state.result.success){
                      ///An area got updated.
                      ///So update the UI with last month record
                      _getLastMonthReportsOfUnits();
                    }
                  }else if(state is GetAreasCompleteState){
                    if(state.areas.success){
                      _getLastMonthReportsOfUnits();
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}