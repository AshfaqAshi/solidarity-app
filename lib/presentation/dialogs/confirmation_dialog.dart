import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';

class ConfirmationDialog extends StatelessWidget{
  String? title;
  String? positiveButtonText;
  String? negativeButtonText;
  String message;
  ConfirmationDialog(this.message,{this.title,this.positiveButtonText,this.negativeButtonText});

  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(title??'Are you sure?'),
      content: Text(message),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context,true);
        }, child: Text(this.positiveButtonText??'YES')),

        TextButton(onPressed: (){
          Navigator.pop(context,false);
        }, child: Text(this.negativeButtonText??'NO')),
      ],
    );
  }
}