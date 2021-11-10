import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/core/misc_bloc.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';
class MembershipCodesDialog extends StatefulWidget {
  _DialogState createState()=>_DialogState();
}

class _DialogState extends State<MembershipCodesDialog>{

  void initState(){
    super.initState();
    print('trigerred');
    context.read<MiscBloc>().add(GetAllMembershipCodesEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: DesignDialog(
        centerAlign: true,
        title: 'Membership Codes',
        child: Column(
          children: [
            BlocBuilder<MiscBloc,MiscState>(
              builder: (context, state){
                if(state is GetAllMembershipCodesState){
                  return LoadingWidget(message: 'Getting Membership Codes',);
                }
                if(state is GetAllMembershipCodesCompleteState){
                  if (state.result.success){
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: state.result.value!.map((code){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Constants.BOX_BORDER_RADIUS),
                              border: Border.all(color: Theme.of(context).colorScheme.primary,
                              width: 1)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(Helper.getUserDesignation(code.designation),
                                style: Theme.of(context).textTheme.bodyText1,),
                                SelectableText(code.code)
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }else{
                    return ErrorText(state.result.userMessage!);
                  }
                }

                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
