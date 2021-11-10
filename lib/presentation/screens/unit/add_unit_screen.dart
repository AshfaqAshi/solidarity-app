import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/report/report_bloc.dart';
import 'package:solidarity_app/application/unit/unit_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/unit/unit.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/scaffold_base.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/screens/user/users_list.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/widgets/custom_form_field.dart';
import 'package:solidarity_app/presentation/widgets/form_button.dart';
import 'package:solidarity_app/presentation/widgets/loaders/loading_widget.dart';

class AddUnitScreen extends ScaffoldBase{
  _ScreenState createState()=>_ScreenState();
}

class _ScreenState extends ScaffoldBaseState<AddUnitScreen>{
  late UserBloc userBloc;
  late UnitBloc unitBloc;

  final _formKey = GlobalKey<FormState>();

  UnitArguments? args;

  TextEditingController txtName = TextEditingController();
  User? president;
  User? secretary;
  User? jSecretary;

  String title()=>args!=null? unitBloc.selectedUnit!.name:'Add new Unit';

  bool showBg()=>true;

  void _populateArea(){
    president = args!.unit.president;
    secretary = args!.unit.secretary;
    jSecretary = args!.unit.jointSecretary;
    txtName.text = args!.unit.name;
  }

  void initState(){
    super.initState();
    userBloc = context.read<UserBloc>();
    unitBloc = context.read<UnitBloc>();
  }

  Widget body(){
    if(args==null){
      if(ModalRoute.of(context)!.settings.arguments!=null){
        args = ModalRoute.of(context)!.settings.arguments as UnitArguments;
        _populateArea();
      }
    }

    return  BlocConsumer<UnitBloc,UnitState>(
            builder: (context, state){
              if(state is GetUnitsState || state is AddUnitState|| state is UpdateUnitState){
                String message='Getting Unit details';
                if(state is AddUnitState) message='Adding new Unit';
                else if(state is UpdateUnitState) message='Updating Unit';
                else message='Getting Units';

                return LoadingWidget(message: message,);
              }

              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      CustomFormField(
                        txtController: txtName,
                        labelText: 'Unit name',
                        onValidate: (value){
                          if(value!=null && value.isEmpty){
                            return 'Please provide Unit Name';
                          }
                          return null;
                        },
                      ),

                      selectorBox('President',selectedUser: president, onValidate: (value){
                        if(president==null){
                          return 'Please choose a President';
                        }
                        return null;
                      }, selectedIds: [secretary?.uid??'', jSecretary?.uid??''],
                          onUserChanged: (newUser){
                            president = newUser;
                          }),
                      selectorBox('Secretary',selectedUser: secretary, onValidate: (value){
                        if(secretary==null){
                          //print('sec is null ${secretary==null}');
                          return 'Please choose a Secretary';
                        }
                        return null;
                      }, selectedIds: [president?.uid??'', jSecretary?.uid??''],
                          onUserChanged: (newUser){
                            secretary = newUser;
                          }),

                      selectorBox('Joint Secretary',selectedUser: jSecretary, onValidate: (value){
                        return null;
                      }, selectedIds: [president?.uid??'', secretary?.uid??''],
                          onUserChanged: (newUser){
                            jSecretary = newUser;
                          }),



                      FormButton(
                        args!=null?'Update Unit':
                        'Add new Unit',
                        onClick: (){
                          if(_formKey.currentState!.validate()){
                            Unit unit = Unit(
                              name: txtName.text,
                              areaId: context.read<AreaBloc>().selectedArea!.id!,
                              presidentId: president!.uid!,
                              secretaryId: secretary!.uid!
                            );
                            if(jSecretary!=null){
                              unit.jointSecretaryId=jSecretary!.uid!;
                            }
                            if(args!=null){
                              //update
                              unit.id = args!.unit.id;
                              ///Also initialize the new [Area] with the Reference values
                              unit.president = president;
                              unit.secretary = secretary;
                              unit.jointSecretary = jSecretary;
                              unitBloc.add(UpdateUnitEvent(unit));
                            }else{
                              unitBloc.add(AddUnitEvent(unit));
                            }

                          }
                        },
                      )
                    ],
                  ),
              );
            },

            listener: (context, state){
              if(state is AddUnitCompleteState){
                if(state.unit.success){
                  Helper.showSnackBar(context, 'Successfully created new ${state.unit.value} Unit');
                  Navigator.pop(context);
                }else{
                  Helper.showSnackBar(context, state.unit.userMessage!);
                }
              }else  if(state is UpdateUnitCompleteState){
                if(state.unit.success){
                  Helper.showSnackBar(context, 'Successfully updated ${state.unit.value} Unit');
                  Navigator.pop(context);
                }else{
                  Helper.showSnackBar(context, state.unit.userMessage!);
                }
              }
            },
          );
  }

  Widget selectorBox(String fieldName,{onValidate(user)?, User? selectedUser, onUserChanged(user)?, List<String>? selectedIds}){
    return FormField<User>(
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
                    if(selectedUser!=null)Text(fieldName,style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 12),),
                    (selectedUser!=null)?
                    Text(selectedUser.name!,style: Theme.of(context).textTheme.bodyText1,):
                    Text(fieldName,style: Theme.of(context).textTheme.bodyText1,)
                  ],
                ),
                Expanded(child: Container(),),
                TextButton(onPressed: ()async{
                  List<String> selectedUidList=selectedIds??[];

                  var user = await  Navigator.pushNamed(context, Screens.USER_LIST, arguments: UserListArguments(selectedUidList: selectedUidList));
                  if(user!=null){
                    if(onUserChanged!=null){
                      setState(() {
                        onUserChanged(user as User);
                      });
                    }
                  }
                }, child: Text(selectedUser==null?'Choose':'Change'))
              ],
            ),

            if(state.hasError)
              Text(state.errorText!,style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).errorColor,
                  fontSize: 12),)
          ],
        );
      },
      validator: (value){
        return onValidate!(value);
      },
    );
  }
}