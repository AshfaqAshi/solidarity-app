import 'package:flutter/material.dart';
class LightText extends StatelessWidget {
  String text;
  double? fontSize;
  bool bold;
  LightText(this.text,{this.fontSize,this.bold=false});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: Theme.of(context).textTheme.caption!
      .copyWith(
      fontSize: fontSize!=null?fontSize:null,
      fontWeight: bold?FontWeight.bold:FontWeight.normal
    ),);
  }
}
