import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Image.asset('assets/images/launcher_icon.png',fit: BoxFit.contain,),
    );
  }
}
