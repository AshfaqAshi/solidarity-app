import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';

class DesignationSelectorWindow extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: DesignDialog(
        centerAlign: true,
        title: 'Choose a Role',
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: Helper.roleHierarchyList.map((role){
              return OutlinedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size?>(Size.fromWidth(200))
                ),
                onPressed:(){
                Navigator.pop(context,role);
              },
              child: Text(Helper.getUserDesignation(role)),
              );
            }).toList()
          ),
        ),
      ),
    );
  }
}
