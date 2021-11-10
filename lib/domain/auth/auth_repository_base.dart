import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/user/user.dart';

abstract class AuthRepositoryBase{
  Future<Result<User>> signInUser(String code);
  Future<Result<bool>> logOutUser();
  Future<Result<User>> getLoggedInUser();
}