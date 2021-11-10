import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';

abstract class ScaffoldBase extends StatefulWidget{
}

abstract class ScaffoldBaseState<Page extends ScaffoldBase> extends State<ScaffoldBase>{
Page get base=>widget as Page;

String title();

bool showBg()=>false;
bool needScrollView()=>true;

Widget body();

@override
Widget build(BuildContext context){
  AppBar appBar = AppBar(title: Text(title()),);

  return Scaffold(
    appBar:appBar,
    body: Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Align(
            alignment: Alignment.topCenter,
            child: LightText('This app is is Beta mode'),),
        ),
        if(showBg())
       SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.topCenter,
              child: SolidarityBox(spaceFiller: false,),
            ),
          ),
       Padding(padding: EdgeInsets.only(top: Constants.SCAFFOLD_PADDING, left: Constants.SCAFFOLD_PADDING,
       right: Constants.SCAFFOLD_PADDING),
       child: needScrollView()? SingleChildScrollView(
         child: ConstrainedBox(
           constraints: BoxConstraints(
             minHeight: MediaQuery.of(context).size.height-appBar.preferredSize.height-(Constants.SCAFFOLD_PADDING*4),
           ),
           child: body(),
         ),
       ):body(),)
      ],
    ),
  );
}

}
