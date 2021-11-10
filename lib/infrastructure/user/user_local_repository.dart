
import 'package:flutter/material.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_repository_base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solidarity_app/domain/user/user_settings.dart';

class UserLocalRepository implements UserRepositoryBase{

  late SharedPreferences prefs;

  Future _getPref()async{
    prefs =await SharedPreferences.getInstance();
  }

  @override
  Future<Result<User>> createNewUser(User user) {
    // TODO: implement createNewUser
    throw UnimplementedError();
  }

  @override
  Future<Result<List<User>>> getAllUsers() {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> getUser(String uid) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Result<UserSettings>> getUserSettings() async{
    try{
      await _getPref();
      bool isDark = prefs.getBool('darkTheme')??true;
      UserSettings settings = UserSettings(themeMode: isDark?ThemeMode.dark:ThemeMode.light);
      return Result(settings);
    }catch(ex){
      return Result(null,success: false,userMessage: 'Failed to get Saved User Settings',
      message: ex.toString());
    }
  }

  @override
  Future<Result<User>> removeUser(User user) {
    // TODO: implement removeUser
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> saveUser(User user) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }

  @override
  Future<Result<UserSettings>> saveUserSettings(UserSettings settings)async {
    try{
      await _getPref();
      prefs.setBool('darkTheme', settings.themeMode==ThemeMode.dark?true:false);
      return Result(settings);
    }catch(ex){
      return Result(null,success: false,userMessage: 'Failed to save User Settings',
          message: ex.toString());
    }
  }

}