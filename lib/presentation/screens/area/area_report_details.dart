import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/report/report_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/report/area_report.dart';
import 'package:solidarity_app/domain/report/field.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/screens/user/users_list.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/dialogs/confirmation_dialog.dart';
import 'package:solidarity_app/presentation/widgets/custom_form_field.dart';
import 'package:solidarity_app/presentation/widgets/form_button.dart';
import 'package:solidarity_app/presentation/widgets/loaders/loading_widget.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';


class AreaReportDetails extends StatefulWidget{
  _ScreenState createState()=>_ScreenState();
}

class _ScreenState extends State<AreaReportDetails>{
  late ReportBloc reportBloc;
  late AreaBloc areaBloc;
  ReportArguments<AreaReport>? args;
  final _formKey = GlobalKey<FormState>();

  Map<String,TextEditingController> textInputs={};
  List<Field> fields=[];
  DateTime? selectedDate;

  void initState(){
    super.initState();
    reportBloc = context.read<ReportBloc>();
    areaBloc = context.read<AreaBloc>();
  }



  Widget build(BuildContext context){
    if(args==null){
      if(ModalRoute.of(context)!.settings.arguments!=null){
        args = ModalRoute.of(context)!.settings.arguments as ReportArguments<AreaReport>;

        reportBloc.add(GetReferenceDetailsEvent(args!.report!));
      }else{
        ///it means no Arguments passed from the caller. So create a dummy one
        args = ReportArguments();
      }
    }
    return Scaffold(
        appBar: AppBar(title: Text('${args!.report!.monthName} Report'),
        actions: [
          if(Helper.hasPrivilege(context.read<UserBloc>().loggedInUser!.designation, UserField.AREA))
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: ()async{
              bool confirmed = await Helper.getConfirmation(context, ConfirmationDialog('Are you sure to '
                  'delete this Report?'));
              if(confirmed){
                reportBloc.add(DeleteReportEvent(args!.report!));
              }
            },
          ),

          if(Helper.hasPrivilege(context.read<UserBloc>().loggedInUser!.designation,UserField.AREA))
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: ()async{
                Helper.navigate(context, Screens.ADD_AREA_REPORT, arguments: ReportArguments<AreaReport>(
                  isUpdate: true,
                  report: args!.report!
                ));
              },
            )
        ],
        ),
        body:
        Padding(
          padding: const EdgeInsets.all(Constants.SCAFFOLD_PADDING),
          child: BlocConsumer<ReportBloc,ReportState>(
            builder: (context, state){


              if(  state is DeleteReportState){
                return LoadingWidget(message: 'Hold on..',);
              }


              return  SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text('Area - ${areaBloc.selectedArea!.name}', style: Theme.of(context).textTheme.caption,),
                      VerticalSpace(),
                      for(Field field in args!.report!.fields!)
                        rowItem(field.name, field.value),
                      if(args!.report!.creator!=null)
                        creatorBox()
                    ],
                  ),
                );
            },

            listener: (context, state){
                 if(state is DeleteReportCompleteState){
                if(state.result.success){
                  Helper.showSnackBar(context, 'Successfully deleted the Report');
                  Navigator.of(context).pop();
                }else{
                  //  print('error ${state.result.message!}');
                  Helper.showSnackBar(context, state.result.userMessage!,error: true);
                }
              }else if(state is GetReferenceDetailsCompleteState){
                   if(!state.result.success){
                     Helper.showSnackBar(context, state.result.userMessage??'');
                   }
                 }
            },
          ),
        )
    );
  }


  Widget rowItem(String label, String content){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: Theme.of(context).textTheme.caption,),
        Text(content),
        VerticalSpace(),
      ],
    );
  }

  Widget creatorBox(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Presented By',style: Theme.of(context).textTheme.bodyText1,),
        Text('${args!.report!.creator!.name!}, ${Helper.getUserDesignation(args!.report!.creator!.designation)}')
      ],
    );
  }
}