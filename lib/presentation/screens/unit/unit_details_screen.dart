import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/report/report_bloc.dart';
import 'package:solidarity_app/application/unit/unit_bloc.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/report/unit_report.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/widgets/unit/unit_details_window.dart';

class UnitDetailsScreen extends StatefulWidget {
  @override
  _UnitDetailsScreenState createState() => _UnitDetailsScreenState();
}

class _UnitDetailsScreenState extends State<UnitDetailsScreen> {

  late UnitBloc unitBloc;
  late ReportBloc reportBloc;

  ReportArguments<UnitReport>? args;

  @override
  void initState(){
    super.initState();
    unitBloc = context.read<UnitBloc>();
    reportBloc = context.read<ReportBloc>();
    reportBloc.add(GetReportsEvent(DateTime.now().year, ReportType.UNIT,
    areaId: context.read<AreaBloc>().selectedArea!.id, unitId: unitBloc.selectedUnit!.id));
    unitBloc.add(GetUnitDetailsEvent(unitBloc.selectedUnit!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${unitBloc.selectedUnit!.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: (){
              showDialog(context: context, builder: (_)=>UnitDetailsWindow());
            },
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
            //add new Unit Report
            Helper.navigate(context, Screens.ADD_UNIT_REPORT);

        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(Constants.SCAFFOLD_PADDING),
        child: BlocConsumer<ReportBloc,ReportState>(
          builder: (context,state){
            //return LoadingWidget(message: 'Loading Reports',);
            if(state is GetReportsState){
              //print('getting reports');
              return LoadingWidget(message: 'Loading Reports',);
            }

            if(state is GetReportsCompleteState){
              if(state.result.success){

                if(reportBloc.unitReports.isEmpty){
                  return Center(child: Text('No records added'),);
                }


              }else{
                return Center(
                  child: ErrorText(state.result.userMessage!),
                );
              }
            }


            return ListView(
              children: reportBloc.unitReports.map((report){

                return ReportBox(report, onTap: (){
                  Helper.navigate(context, Screens.UNIT_REPORT_DETAILS,
                      arguments: ReportArguments<UnitReport>(report: report,));
                });

              }).toList()
            );
          },

          listener: (context,state){

          },
        ),
      ),
    );
  }
}
