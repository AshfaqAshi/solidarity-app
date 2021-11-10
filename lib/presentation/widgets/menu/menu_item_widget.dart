import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/core/menu_item.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';

class MenuItemWidget extends StatelessWidget {
  MenuItem item;
   MenuItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(item.icon,color: Theme.of(context).colorScheme.onBackground,),
        HorizontalSpace(),
        Text(item.title)
      ],
    );
  }
}
