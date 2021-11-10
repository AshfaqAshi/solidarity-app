
import 'package:flutter/cupertino.dart';

class HorizontalSpace extends StatelessWidget{
  double width;
  HorizontalSpace({this.width=15});

  Widget build(BuildContext context){
    return SizedBox(width: width,);
  }
}