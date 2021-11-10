import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/core/extensions/bottom_wave_clipper.dart';

class Waver extends StatelessWidget {
  double borderRadius;
  double? height;
  Waver({required this.borderRadius, this.height});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadius),topRight: Radius.circular(borderRadius)),
      child:  Container(
          height: height??40,
          color: Theme.of(context).colorScheme.primary,
        ),
    );
  }
}
