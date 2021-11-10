import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/presentation/core/app_theme.dart';

class WelcomeCard extends StatelessWidget {

  late UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = context.read<UserBloc>();

    return Card(
      child: Container()
    );
  }
}
