part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class GetLoggedInUserEvent extends UserEvent{}


class GetUserEvent extends UserEvent{
  final String uid;
  GetUserEvent(this.uid);
}

class GetAllUsersEvent extends UserEvent{}
class LogOutEvent extends UserEvent{}
class SaveUserEvent extends UserEvent{
  final User user;
  SaveUserEvent(this.user);
}
