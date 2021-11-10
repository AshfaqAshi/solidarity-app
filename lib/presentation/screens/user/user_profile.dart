import 'package:flutter/material.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/scaffold_base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/widgets/custom_form_field.dart';
import 'package:solidarity_app/presentation/widgets/form_button.dart';

class UserProfile extends ScaffoldBase{
  _ScreenState createState()=>_ScreenState();
}

class _ScreenState extends ScaffoldBaseState<UserProfile>{

  bool showBg()=>true;
  String title()=>'Profile';

  late UserBloc bloc;

  TextEditingController txtName=TextEditingController();
  TextEditingController txtPhone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void initState(){
    super.initState();
    bloc = context.read<UserBloc>();
    txtName.text=bloc.loggedInUser!.name??'';
    txtPhone.text=bloc.loggedInUser!.phone??'';
  }
  Widget body(){
    return BlocConsumer<UserBloc,UserState>(
      builder: (context, state){
        if(state is SaveUserState){
          return LoadingWidget(message: 'Saving your data',);
        }
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(bloc.loggedInUser!.area!=null)
                LightText('Area: ${bloc.loggedInUser!.area!.name}',fontSize: 16,),
              if(bloc.loggedInUser!.unit!=null)
                LightText('Unit: ${bloc.loggedInUser!.unit!.name}',fontSize: 16,),
              LightText('Role: ${Helper.getUserDesignation(bloc.loggedInUser!.designation)}',fontSize: 16,),
              VerticalSpace(),
              CustomFormField(
                txtController: txtName,
                labelText: 'Name',
                onValidate: (value){
                  if(value!=null){
                    if(value.isEmpty)return 'Please provide a name';
                  }
                  return null;
                },
              ),
              VerticalSpace(),
              CustomFormField(
                txtController: txtPhone,
                labelText: 'Phone',
                number: true,
                onValidate: (value){
                  return null;
                },
              ),
              VerticalSpace(),
              if(bloc.loggedInUser!.designation==UserDesignation.ADMIN)
                UserRoleWidget(bloc.loggedInUser!),
              FormButton('Save', onClick: (){
                if(_formKey.currentState!.validate()){
                  bloc.loggedInUser!.name = txtName.text;
                  if(txtPhone.text.isNotEmpty)
                  bloc.loggedInUser!.phone = txtPhone.text;
                  bloc.add(SaveUserEvent(bloc.loggedInUser!));
                }
              })
            ],
          ),
        );
      },

      listener: (context,state){
        if(state is SaveUserCompleteState){
          if(state.result.success){
            Helper.showSnackBar(context, 'Successfully updated!');
            bloc.setLoggedInUser(state.result.value!);
            Navigator.pop(context);
          }else{
            Helper.showSnackBar(context, state.result.userMessage!,error: true);
          }
        }
      },
    );
  }
}