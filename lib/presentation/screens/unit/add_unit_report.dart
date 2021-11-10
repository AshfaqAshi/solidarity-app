import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/report/report_bloc.dart';
import 'package:solidarity_app/application/unit/unit_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/report/area_report.dart';
import 'package:solidarity_app/domain/report/field.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/report/unit_report.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/screens/user/users_list.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/widgets/custom_form_field.dart';
import 'package:solidarity_app/presentation/widgets/form_button.dart';
import 'package:solidarity_app/presentation/widgets/loaders/loading_widget.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';


class AddUnitReportScreen extends StatefulWidget{
  _ScreenState createState()=>_ScreenState();
}

class _ScreenState extends State<AddUnitReportScreen>{
  late ReportBloc reportBloc;
  late UnitBloc unitBloc;
  ReportArguments<UnitReport>? args;
  final _formKey = GlobalKey<FormState>();

  Map<String,TextEditingController> textInputs={};
  List<Field> fields=[];
  DateTime? selectedDate;


  bool _isMultiline(String key){
    int index = fields.indexWhere((data)=>data.name==key);
    if(index>=0){
      if(fields[index].type==FieldTypes.TEXT_AREA){
        return true;
      }
    }
    return false;
  }
  _populateFields(){
    if(args!.isUpdate){
      textInputs.forEach((key, value) {
        value.text = args!.report!.fields!.firstWhere((element) => element.name==key).value??'';
      });

      selectedDate = DateTime(args!.report!.year!,args!.report!.monthCode!);
    }
  }

  void initState(){
    super.initState();
    reportBloc = context.read<ReportBloc>();
    unitBloc = context.read<UnitBloc>();
    reportBloc.add(GetFieldsEvent(ReportType.UNIT));
  }

  void dispose(){
    textInputs.forEach((key, value){
      value.dispose();
    });
    super.dispose();
  }



  Widget build(BuildContext context){
    if(args==null){
      if(ModalRoute.of(context)!.settings.arguments!=null){
        args = ModalRoute.of(context)!.settings.arguments as ReportArguments<UnitReport>;
      }else{
        ///it means no Arguments passed from the caller. So create a dummy one
        args = ReportArguments();
      }
    }
    return Scaffold(
        appBar: AppBar(title: Text(args!.isUpdate?'Update':'Add new Unit Report'),),
        body:
        Padding(
          padding: const EdgeInsets.all(Constants.SCAFFOLD_PADDING),
          child: BlocConsumer<ReportBloc,ReportState>(
            builder: (context, state){


              if(state is GetFieldsState || state is AddReportState || state is UpdateReportState){
                String? message='Getting fields from Google Sheet';
                if(state is AddReportState)
                  message='Adding new Report';
                else if(state is UpdateReportState)
                  message='Updating this Report';

                return LoadingWidget(message: message,);
              }

              if(state is GetFieldsCompleteState){
                if(!state.fields.success){
                  return Center(child: ErrorText(state.fields.userMessage!),);
                }else{
                  fields = List.from(state.fields.value!);
                }
              }

              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text('Unit - ${unitBloc.selectedUnit!.name}', style: Theme.of(context).textTheme.caption,),
                      VerticalSpace(),
                      for(String key in textInputs.keys)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomFormField(
                            multiline: _isMultiline(key),
                            txtController: textInputs[key],
                            labelText: key,
                            onValidate: (value){
                              if(textInputs[key]!.text.isEmpty){
                                return 'Please provide this field';
                              }
                              return null;
                            },
                          ),
                        ),
                      VerticalSpace(),
                      monthSelectorBox(),
                      FormButton(
                        args!.isUpdate?'Update Report':
                        'Add new Unit Report',
                        onClick: (){
                          if(_formKey.currentState!.validate()){
                            Helper.removeTextBoxFocus(context);
                            //populate fields with value
                            fields.forEach((field) {
                              if(field.type==FieldTypes.TEXT || field.type==FieldTypes.TEXT_AREA){
                                field.value=textInputs[field.name]!.text;
                              }else{
                                //TODO: Implement other Field Types
                              }
                            });
                            if(args!.isUpdate){
                              args!.report!.creatorId = context.read<UserBloc>().loggedInUser!.uid;
                              args!.report!.fields = fields;
                              args!.report!.unitId=unitBloc.selectedUnit!.id;
                              args!.report!.areaId = context.read<AreaBloc>().selectedArea!.id;
                              args!.report!.monthCode = selectedDate!.month;
                              args!.report!.monthName = Helper.getMonthNameFromCode(selectedDate!.month);
                              args!.report!.year=selectedDate!.year;
                              reportBloc.add(UpdateReportEvent(args!.report!));
                            }else{
                              UnitReport report = UnitReport(
                                unitId: unitBloc.selectedUnit!.id,
                                  areaId: context.read<AreaBloc>().selectedArea!.id,
                                  report: Report(
                                      creatorId:context.read<UserBloc>().loggedInUser!.uid,
                                      monthName: Helper.getMonthNameFromCode(selectedDate!.month),
                                      monthCode: selectedDate!.month,
                                      year: selectedDate!.year,
                                      fields: fields
                                  )
                              );
                              reportBloc.add(AddReportEvent(report));
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            },

            listener: (context, state){
              if(state is GetFieldsCompleteState){
                if(state.fields.success){
                  state.fields.value!.forEach((field) {
                    if(field.type==FieldTypes.TEXT || field.type==FieldTypes.TEXT_AREA)
                      textInputs.addAll({field.name: TextEditingController()});
                  });
                  _populateFields();
                }
              }else if(state is AddReportCompleteState){
                if(state.result.success){
                  Helper.showSnackBar(context, 'Successfully uploaded the Report');
                  Navigator.of(context).pop();
                }else{
                  //  print('error ${state.result.message!}');
                  Helper.showSnackBar(context, state.result.userMessage!,error: true);
                }
              }else if(state is UpdateReportCompleteState){
                if(state.result.success){
                  Helper.showSnackBar(context, 'Successfully updated the Report');
                  Navigator.of(context).pop();
                }else{
                  //  print('error ${state.result.message!}');
                  Helper.showSnackBar(context, state.result.userMessage!,error: true);
                }
              }
            },
          ),
        )
    );
  }


  Widget monthSelectorBox(){
    return FormField<DateTime>(
      builder: (state){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.person),
                HorizontalSpace(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(selectedDate!=null)Text('Month',style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 12),),
                    (selectedDate!=null)?
                    Text(Helper.getDateString(selectedDate,monthAndYearOnly: true),style: Theme.of(context).textTheme.bodyText1,):
                    Text('Choose a Month',style: Theme.of(context).textTheme.bodyText1,)
                  ],
                ),
                Expanded(child: Container(),),
                TextButton(onPressed: ()async{
                  Helper.removeTextBoxFocus(context);
                  DateTime? date = await showMonthPicker(context: context, initialDate:
                  selectedDate==null?DateTime.now():selectedDate!);
                  if(date!=null){
                    setState(() {
                      selectedDate = date;
                    });
                  }
                }, child: Text(selectedDate==null?'Choose':'Change'))
              ],
            ),

            if(state.hasError)
              Text(state.errorText!,style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).errorColor,
                  fontSize: 12),)
          ],
        );
      },
      validator: (value){
        if(selectedDate==null){
          return 'Please select the month to which this Report belongs.';
        }
        return null;
      },
    );
  }
}