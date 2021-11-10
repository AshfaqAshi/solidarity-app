import 'package:flutter/material.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
class UserBox extends StatelessWidget {
  final User user;
  final VoidCallback onPress;
  final bool enabled;
  UserBox(this.user,{required this.onPress, this.enabled=true});

  Color _getBgColor(BuildContext context){
    return Theme.of(context).colorScheme.background;
  }
  @override
  Widget build(BuildContext context) {
    return OutlinedButtonTheme(
      data: OutlinedButtonThemeData(
        style: ButtonStyle(
          alignment: Alignment.centerLeft
        )
      ),
      child: OutlinedButton(
        onPressed:enabled? onPress:null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name!,style: Theme.of(context).textTheme.bodyText1,),
            Text(Helper.getUserDesignation(user.designation), style: Theme.of(context).textTheme.caption,)
          ],
        ),
      ),
    );
  }
}
