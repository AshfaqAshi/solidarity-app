import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/core/constants.dart';

import '../all_widgets.dart';

class LoadingWidget extends StatefulWidget {
  double size;
  String? message;
  LoadingWidget({this.size=30,this.message});
  _loadingState createState()=>_loadingState();
}

class _loadingState extends State<LoadingWidget> with SingleTickerProviderStateMixin{
  late AnimationController animatedController;
  late Animation<double> animation;

  void initState(){
    super.initState();
    animatedController = AnimationController(vsync: this,duration: Duration(milliseconds: 400) );
    animation = Tween<double>(begin: 0.0,end: 1.0).animate(
      CurvedAnimation(parent: animatedController, curve: Curves.fastOutSlowIn)
    );
    animatedController.forward();
  }

  void dispose(){
    animatedController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context){
    return Center(
      child: ScaleTransition(
        scale: animation,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.BOX_BORDER_RADIUS),
            color: Theme.of(context).dialogBackgroundColor
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Theme.of(context).colorScheme.onBackground,),
              if(widget.message!=null)
                VerticalSpace(),
              if(widget.message!=null)
                Text(widget.message!,style: Theme.of(context).textTheme.bodyText2,)
            ],
          ),
        ),
      ),

    );
  }
}