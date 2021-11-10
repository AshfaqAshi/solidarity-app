import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget{
  double height;
  VerticalSpace({this.height=15});

  Widget build(BuildContext context){
    return SizedBox(height: height,);
  }
}