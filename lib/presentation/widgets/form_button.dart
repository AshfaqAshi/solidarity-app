import 'package:flutter/material.dart';

class FormButton extends StatelessWidget{
  VoidCallback onClick;
  String text;
  Widget? icon;
  FormButton(this.text,{required this.onClick,this.icon});
  Widget build(BuildContext context){

    if(icon!=null){
      return OutlinedButton(onPressed: onClick, child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: icon!,
          ),
          SizedBox(width: 10,),
          Text(text)
        ],
      ));
    }
    return Align(
      alignment: Alignment.bottomRight,
        child: ElevatedButton(onPressed: onClick, child: Text(text)));
  }
}