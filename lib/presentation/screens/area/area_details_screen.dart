import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/report/report_bloc.dart';
import 'package:solidarity_app/application/unit/unit_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/report/area_report.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/screens/area/add_area_report.dart';
import 'package:solidarity_app/presentation/screens/user/users_list.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/widgets/area/area_details_window.dart';
import 'package:solidarity_app/presentation/widgets/custom_form_field.dart';
import 'package:solidarity_app/presentation/widgets/form_button.dart';
import 'package:solidarity_app/presentation/widgets/loaders/loading_widget.dart';

class AreaDetailsScreen extends StatefulWidget{
  _ScreenState createState()=>_ScreenState();
}

class _ScreenState extends State<AreaDetailsScreen> with SingleTickerProviderStateMixin{
  late ReportBloc reportBloc;
  late AreaBloc areaBloc;
  late UnitBloc unitBloc;

  late TabController tabController;

  List<String> titles=['Reports', 'Units'];

  bool _fetchedLastMonthReports=false;
  _getLastMonthReportsOfUnits(){
    unitBloc.units.forEach((unit){
      DateTime dateTime = DateTime.now();
      DateTime lastMonth = DateTime(dateTime.year,dateTime.month-1,dateTime.day);
      context.read<ReportBloc>().add(GetReportForMonthEvent(ReportType.UNIT, lastMonth.year,
          lastMonth.month, unitId: unit.id, areaId: areaBloc.selectedArea!.id));
    });
    _fetchedLastMonthReports=true;
  }

  _onTabChanged(){
    if(!tabController.indexIsChanging && tabController.index==1 && !_fetchedLastMonthReports){
      _getLastMonthReportsOfUnits();
    }
  }
  void initState(){
    super.initState();
    reportBloc = context.read<ReportBloc>();
    areaBloc = context.read<AreaBloc>();
    unitBloc = context.read<UnitBloc>();
    tabController = TabController(length: 2, vsync: this);
    areaBloc.add(GetAreaDetailsEvent(areaBloc.selectedArea!));
    reportBloc.add(GetReportsEvent(DateTime.now().year, ReportType.AREA, areaId: areaBloc.selectedArea!.id));
    unitBloc.add(GetUnitsEvent(areaBloc.selectedArea!.id!));
    tabController.addListener(_onTabChanged);

  }

  void dispose(){
    tabController.removeListener(_onTabChanged);
    super.dispose();
  }


  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Text('${areaBloc.selectedArea!.name}'),
        actions: [

          IconButton(onPressed: (){
            showDialog(context: context, builder: (_)=>AreaDetailsWindow());
          }, icon: Icon(Icons.info)),
          if(context.read<UserBloc>().loggedInUser!.designation!=UserDesignation.ADMIN)
            MenuPopUpButton(),
        ],

        bottom: TabBar(
          labelPadding: EdgeInsets.only(bottom: Constants.TAB_BAR_LABEL_PADDING),
          controller: tabController,
          tabs: [
            Text(titles[0]),
            Text(titles[1])
          ],
        ),),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            if(tabController.index==0){
              //add new Area Report
              Helper.navigate(context, Screens.ADD_AREA_REPORT);
            }else{
              //add new unit
              Helper.navigate(context, Screens.ADD_UNIT);
            }
          },
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            ///Area reports
            Padding(
              padding: const EdgeInsets.all(Constants.SCAFFOLD_PADDING),
              child: BlocConsumer<ReportBloc,ReportState>(
                builder: (context, state){
                  if(state is GetReportsState){
                    return LoadingWidget(message: 'Getting reports',);
                  }

                  if(state is GetReportsCompleteState){
                    if(!state.result.success){
                      return Center(
                        child: ErrorText(state.result.userMessage!),
                      );
                    }
                  }

                  if(reportBloc.areaReports.isEmpty){
                    return Center(child: Text('No records added'),);
                  }

                  return ListView(
                      children: reportBloc.areaReports.map((report){

                        return ReportBox(report, onTap: (){
                          Helper.navigate(context, Screens.AREA_REPORT_DETAILS,
                              arguments: ReportArguments<AreaReport>(report: report));
                        });

                      }).toList()
                  );
                },

                listener: (context, state){
                  if(state is GetReportsCompleteState){
                    if(!state.result.success && state.result.value![0].runtimeType==AreaReport){
                      Helper.showSnackBar(context, state.result.userMessage!,error: true);
                    }
                  }else if(state is AddReportCompleteState){
                    if(state.result.success){
                     if(state.result.value!.type==ReportType.UNIT){
                       ///New unit added.
                       ///So update the UI with last month record
                       _getLastMonthReportsOfUnits();
                     }
                    }
                  }else if(state is UpdateReportCompleteState){
                    if(state.result.success){
                      if(state.result.value!.type==ReportType.UNIT){
                        ///A unit got updated.
                        ///So update the UI with last month record
                        _getLastMonthReportsOfUnits();
                      }
                    }
                  }

                },
              ),
            ),

            ///Unit List
            Padding(
              padding: const EdgeInsets.all(Constants.SCAFFOLD_PADDING),
              child: BlocConsumer<UnitBloc,UnitState>(
                builder: (context, state){

                  if(state is GetUnitsState){
                    return LoadingWidget();
                  }

                  if(state is GetUnitsCompleteState){
                    if(state.result.success){

                      if(unitBloc.units.isEmpty){
                        return Center(child: Text('No Units added'),);
                      }

                    }else{
                      return Center(
                        child: Text(state.result.userMessage!,style: Theme.of(context).textTheme.bodyText1!
                            .copyWith(color: Theme.of(context).errorColor),),
                      );
                    }
                  }


                  return ListView(
                      children: unitBloc.units.map((unit){
                        ///Get the last report for this Area

                        return BlocConsumer<ReportBloc,ReportState>(
                          buildWhen: (previous, current){
                            if(current is GetReportForMonthCompleteState ){
                              if(current.result.success){
                                if(current.type==ReportType.UNIT && current.unitId==unit.id){
                                  return true;
                                }
                              }else{
                                ///in case no report is found, it returns error
                                ///with
                                ///error code NO_DATA
                                if(current.result.errorCode==ErrorCodes.NO_DATA){
                                  if(current.type==ReportType.UNIT && current.unitId==unit.id){
                                    return true;
                                  }
                                }
                              }

                            }else if(current is GetReportForMonthState){
                              if(current.type==ReportType.UNIT && current.unitId==unit.id){
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
                              color: Theme.of(context).colorScheme.secondary,
                              onTap: (){
                                unitBloc.setSelectedUnit(unit);
                                Helper.navigate(context, Screens.UNIT_DETAILS);
                              },
                              title: unit.name,
                              content: Helper.getReportContentAsString(hasError, isLoading, report,
                              max: 100),
                            );
                          },

                          listenWhen: (previous, current){
                            if(current is AddReportCompleteState){
                              if(current.result.success){
                                if(current.result.value!.type==ReportType.UNIT){
                                  //new report added, update UI to
                                  //get latest data to be displayed as Last Month Report
                                  return true;
                                }
                              }
                            }else if(current is UpdateReportCompleteState){
                              if(current.result.success){
                                if(current.result.value!.type==ReportType.UNIT){
                                  //new report added, update UI to
                                  //get latest data to be displayed as Last Month Report
                                  return true;
                                }
                              }
                            }
                            return false;
                          },

                          listener: (context,state){
                            if(state is AddReportCompleteState || state is UpdateReportCompleteState){
                                _getLastMonthReportsOfUnits();
                            }
                          },
                        );
                      }).toList()
                  );
                },

                listener: (context, state){
                  if(state is GetUnitsCompleteState){
                    if(!state.result.success){
                      Helper.showSnackBar(context, state.result.userMessage!,error: true);
                    }
                  }
                },
              ),
            ),
          ],
        )
    );
  }

  

}