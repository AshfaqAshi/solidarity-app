import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:solidarity_app/domain/auth/auth_factory.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial());

  AuthFactory authFactory = AuthFactory.instance;
  UserFactory userFactory = UserFactory.instance;

  User? get loggedInUser=>userFactory.loggedInUser;
  User? get selectedUser=>userFactory.selectedUser;

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if(event is GetLoggedInUserEvent){
      yield GetLoggedInUserState();
      Result<User> result=await authFactory.getLoggedInUser();
      yield GetLoggedInUserStateComplete(result);
    }else if(event is GetUserEvent){
      yield GetUserState();
      Result<User> result=await userFactory.getUser(event.uid);
      yield GetUserStateComplete(result);
    }else if(event is GetAllUsersEvent){
      yield GetAllUsersState();
      Result<List<User>> result=await userFactory.getAllUsers();
      yield GetAllUsersCompleteState(result);
    }else if(event is LogOutEvent){
      yield LogOutState();
      var result=await authFactory.logOutUser();
      yield LogOutCompleteState(result);
    }else if(event is SaveUserEvent){
      yield SaveUserState();
      var result=await userFactory.saveUser(event.user);
      yield SaveUserCompleteState(result);
    }
  }

  void setSelectedUser(User user){
    userFactory.setSelectedUser(user);
  }

  void setLoggedInUser(User user){
    userFactory.setLoggedInUser(user);
  }

}
