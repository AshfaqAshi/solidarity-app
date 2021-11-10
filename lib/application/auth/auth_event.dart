part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthenticateEvent extends AuthEvent{
  final String memCode;
  AuthenticateEvent(this.memCode);
}

class AuthCompleteEvent extends AuthEvent{
  final Result<User> result;
  AuthCompleteEvent(this.result);
}


