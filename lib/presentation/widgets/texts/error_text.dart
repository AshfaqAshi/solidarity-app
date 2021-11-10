import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String text;
  ErrorText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text,style: Theme.of(context).textTheme.bodyText1!
        .copyWith(color: Theme.of(context).errorColor),);
  }
}
