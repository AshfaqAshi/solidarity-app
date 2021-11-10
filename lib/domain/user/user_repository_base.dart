
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_settings.dart';

abstract class UserRepositoryBase{
  Future<Result<User>> createNewUser(User user);
  Future<Result<User>> getUser(String uid);
  Future<Result<User>> removeUser(User user);
  Future<Result<List<User>>> getAllUsers();
  Future<Result<User>> saveUser(User user);
  Future<Result<UserSettings>> getUserSettings();
  Future<Result<UserSettings>> saveUserSettings(UserSettings settings);
}