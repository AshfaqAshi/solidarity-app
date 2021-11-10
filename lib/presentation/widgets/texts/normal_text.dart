import 'package:flutter/material.dart';

class NormalText extends StatelessWidget{
  String text;
  double? fontSize;
  bool bold;
  Color? color;

  NormalText(this.text,{this.color, this.fontSize=14, this.bold=false});
  Widget build(BuildContext context){
    return Text(text,
    style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: fontSize, color: color, fontWeight:bold?FontWeight.bold:FontWeight.normal ),);
  }
}