import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/report/report_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/report/report.dart';
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

class AddAreaScreen extends ScaffoldBase{
  _ScreenState createState()=>_ScreenState();
}

class _ScreenState extends ScaffoldBaseState<AddAreaScreen> with SingleTickerProviderStateMixin{
  late UserBloc userBloc;
  late AreaBloc areaBloc;

  final _formKey = GlobalKey<FormState>();

  AreaArguments? args;

  TextEditingController txtName = TextEditingController();
  User? president;
  User? secretary;
  User? jSecretary;

  String title()=>args!=null?args!.area.name:'Add new Area';

  bool showBg()=>true;

  void _populateArea(){
    president = args!.area.president;
    secretary = args!.area.secretary;
    jSecretary = args!.area.jointSecretary;
    txtName.text = args!.area.name;
  }
  void initState(){
    super.initState();
    userBloc = context.read<UserBloc>();
    areaBloc = context.read<AreaBloc>();

  }

  Widget body(){
    if(args==null){
      if(ModalRoute.of(context)!.settings.arguments!=null){
        args = ModalRoute.of(context)!.settings.arguments as AreaArguments;
        _populateArea();
      }
    }

    return  BlocConsumer<AreaBloc,AreaState>(
              builder: (context, state){
                if( state is AddAreaState || state is UpdateAreaState){
                  String message = 'Adding new Area ';
                  if(state is UpdateAreaState){
                    message = 'Updating Area';
                  }
                  return LoadingWidget(message: message,);
                }

               return  Form(
                   key: _formKey,
                   autovalidateMode: AutovalidateMode.disabled,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       CustomFormField(
                           txtController: txtName,
                           labelText: 'Area name',
                           onValidate: (value){
                             if(value!=null && value.isEmpty){
                               return 'Please provide Area Name';
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
                         args!=null?'Update Area':
                         'Add new Area',
                         onClick: (){
                           if(_formKey.currentState!.validate()){
                             Helper.removeTextBoxFocus(context);
                             Area area = Area(
                               name: txtName.text,
                               presidentId: president!.uid!,
                               secretaryId: secretary!.uid!,
                             );
                             if(jSecretary!=null){
                               area.jointSecretaryId=jSecretary!.uid!;
                             }
                            if(args!=null){
                              ///update
                             area.id = args!.area.id;
                             ///Also initialize the new [Area] with the Reference values
                             area.president = president;
                             area.secretary = secretary;
                             area.jointSecretary = jSecretary;
                              areaBloc.add(UpdateAreaEvent(area));
                            }else{

                              areaBloc.add(AddAreaEvent(area));
                            }
                           }
                         },
                       )
                     ],
                   ),
                 );
              },

              listener: (context, state){
                if(state is AddAreaCompleteState){
                  if(state.result.success){
                    Helper.showSnackBar(context, 'Successfully created new Area');
                    Navigator.pop(context);
                  }else{
                    Helper.showSnackBar(context, state.result.userMessage!,error: true);
                  }
                }else if(state is UpdateAreaCompleteState){
                  if(state.result.success){
                    Helper.showSnackBar(context, 'Successfully updated the Area');
                    Navigator.pop(context);
                  }else{
                    Helper.showSnackBar(context, state.result.userMessage!,error: true);
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
                Helper.removeTextBoxFocus(context);
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