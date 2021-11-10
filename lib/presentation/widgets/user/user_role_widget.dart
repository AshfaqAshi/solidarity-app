import 'package:flutter/material.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/presentation/dialogs/confirmation_dialog.dart';

import '../../dialogs/designation_selector_window.dart';
import '../horizontal_space.dart';
class UserRoleWidget extends StatelessWidget {
  final User user;
  UserRoleWidget(this.user);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(Helper.getUserDesignation(user.designation),style: Theme.of(context).textTheme.headline6,),
        HorizontalSpace(),
        if(user.designation!=UserDesignation.UNIT_MEMBER)
          TextButton(
            onPressed: ()async{
              var selectedRole = await showDialog(
                  context: context,
                  builder: (_)=>DesignationSelectorWindow()
              ) as String?;
              if(selectedRole!=null){
               bool _confirmed = await Helper.getConfirmation(context,
               ConfirmationDialog('Are you sure to change the role of ${user.name} from '
                   '${Helper.getUserDesignation(user.designation)} to '
                   '${Helper.getUserDesignation(selectedRole)}',
               title: 'Confirm Role Change',));

               if(_confirmed){
                 //now check if [loggedInUser] has the permission to change to the
                 //given role.
                 int loggedInUserIndex = Helper.roleHierarchyList.indexOf(
                     context.read<UserBloc>().loggedInUser!.designation
                 );
                 int newRoleIndex = Helper.roleHierarchyList.indexOf(selectedRole);
                 if(newRoleIndex>loggedInUserIndex){
                   //no permission
                   Helper.showSnackBar(context, 'You do not have the permission to make this change',
                   error: true);
                 }else{
                   user.designation=selectedRole;
                   context.read<UserBloc>().add(SaveUserEvent(user));
                 }
               }
              }
            },
            child: Text('Change'),
          )
      ],
    );
  }
}
