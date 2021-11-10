import 'package:flutter/material.dart';
class SolidarityBox extends StatelessWidget {
  bool spaceFiller;
  SolidarityBox({this.spaceFiller=true});
  @override
  Widget build(BuildContext context) {
    if(spaceFiller){
      return Expanded(
        child: Center(
          child: _box(context),
        ),
      );
    }
    return _box(context);
  }

  Widget _box(BuildContext context){
    return Opacity(
      opacity:Theme.of(context).colorScheme.brightness==Brightness.dark?
      0.5:0.2,
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2,
        height: 150,
        child: Center(child: Image.asset('assets/images/logo.png',fit: BoxFit.contain,),),
      ),
    );
  }
}
