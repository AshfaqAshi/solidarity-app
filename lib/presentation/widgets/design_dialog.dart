import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';

class DesignDialog extends StatelessWidget{
  Widget child;
  String title;
  double padding;
  bool centerAlign;
  List<Widget>? actions;
  DesignDialog({required this.child, required this.title,this.padding=Constants.DIALOG_PADDING,
  this.actions,this.centerAlign=false});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: centerAlign?CrossAxisAlignment.center:CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(Constants.DIALOG_BORDER_RADIUS),topRight: Radius.circular(Constants.DIALOG_BORDER_RADIUS)),
              child:  Container(
                padding: EdgeInsets.all(Constants.DIALOG_TITLE_PADDING),
                color: Theme.of(context).colorScheme.primary,
                child:
                Row(
                  children: [
                    Expanded(child: Text('$title',style: Theme.of(context).textTheme.headline5!
                        .copyWith(color:Theme.of(context).colorScheme.onPrimary ),)),
                    if(actions!=null)
                      for(Widget widget in actions!)
                        widget
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Constants.DIALOG_PADDING),
              child: child,
            )
          ],
        );
  }
}
