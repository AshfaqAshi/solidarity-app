import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solidarity_app/application/area/area_bloc.dart';
import 'package:solidarity_app/application/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
import 'package:solidarity_app/presentation/widgets/custom_form_field.dart';
import 'package:solidarity_app/presentation/widgets/form_button.dart';
import 'package:blur/blur.dart';

class LoginScreen extends StatefulWidget{
  _loginScreenState createState()=>_loginScreenState();
}

class _loginScreenState extends State<LoginScreen>{
  TextEditingController txtType = TextEditingController();

  late AuthBloc authBloc;
  final _formKey = GlobalKey<FormState>();

  void initState(){
    super.initState();
    authBloc = context.read<AuthBloc>();
  }
  Widget build(BuildContext context){
    return Scaffold(
      body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child:  Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Blur(
                    blurColor: Colors.black,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/images/back_cover.jpg',fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/logo.png',),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Constants.SCAFFOLD_PADDING),
                  child: Center(
                    child: Card(
                      elevation: Constants.CARD_ELEVATION,
                      child: Padding(
                        padding: const EdgeInsets.all(Constants.CARD_PADDING),
                        child: Column(
                           mainAxisSize: MainAxisSize.min,
                          children: [
                                     CustomFormField(
                                       prefixIcon: Icons.person,
                                       //hintText: 'Type your membership code',
                                       labelText: 'Membership Code',
                                       txtController: txtType,
                                       onValidate: (value){
                                         if(value?.isEmpty??true) return 'Please provide a valid Membership Code';
                                         return null;
                                       },
                                     ),
                                     BlocConsumer<AuthBloc,AuthState>(
                                       builder: (context, state){
                                         if(state is AuthenticateState){
                                           return LoadingWidget();
                                         }

                                         return FormButton('Login with Google',
                                           icon: Image.asset('assets/images/google_icon.png',fit: BoxFit.contain,),
                                           onClick: (){
                                             if(_formKey.currentState!.validate()){
                                               authBloc.add(AuthenticateEvent(txtType.text));
                                             }
                                           },);
                                       },

                                       listener: (context, state){
                                         if(state is AuthCompleteState){
                                           if(!state.result.success){
                                             Helper.showSnackBar(context, state.result.userMessage!,error: true);
                                           }else{
                                             ///Get user designation type and navigate accordingly
                                             if(state.result.value!.designation!=UserDesignation.ADMIN){
                                               if(state.result.value!.areaId==null || state.result.value!.unitId==null){
                                                 ///user has not configured his area and unit. so navigate him to
                                                 ///the selector screen
                                                 Helper.navigate(context, Screens.AREA_UNIT_SELECTOR,pushReplace: true);

                                               }else{
                                                 context.read<AreaBloc>().setSelectedArea(state.result.value!.area!);
                                                 Helper.navigate(context, Screens.AREA_DETAILS,
                                                     pushReplace: true,arguments: AreaArguments(state.result.value!.area!));
                                               }
                                             }else{
                                               Helper.navigate(context, Screens.AREA_LIST,pushReplace: true);
                                             }
                                           }
                                         }
                                       },
                                     )

                          ],
                          ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

        )
    );
  }
}