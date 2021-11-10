part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthenticateState extends AuthState{}

class AuthCompleteState extends AuthState{
  final Result<User> result;
  AuthCompleteState(this.result);
}



