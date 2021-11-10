import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';

class DesignTile extends StatelessWidget {
  String title;
  String content;
  VoidCallback onTap;
  Color? color;

  DesignTile(
      {required this.title, required this.content, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:Constants.LIST_TILE_TITLE_PADDING),
      child: ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
          style: ButtonStyle(
            alignment: Alignment.topLeft,
            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.background),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Constants.LIST_TILE_BORDER_RADIUS),
                      topRight:  Radius.circular(Constants.LIST_TILE_BORDER_RADIUS))
              )
            )
          )
        ),
        child: ElevatedButton(
          onPressed: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(Constants.LIST_TILE_TITLE_PADDING),
                  decoration: BoxDecoration(
                      color: color?? Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Constants.LIST_TILE_BORDER_RADIUS),
                          topRight:  Radius.circular(Constants.LIST_TILE_BORDER_RADIUS)
                      )
                  ),
                  child: Text(title,style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).colorScheme.onPrimary),),
                ),

                Padding(
                  padding: EdgeInsets.all(Constants.LIST_TILE_CONTENT_PADDING),
                  child: Text(content,style: Theme.of(context).textTheme.bodyText2,),
                )
              ],
            ),
        ),
      ),
    );
  }
}
