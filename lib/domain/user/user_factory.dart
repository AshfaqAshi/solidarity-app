import 'package:solidarity_app/domain/area/area_factory.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/unit/unit_factory.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_repository_base.dart';
import 'package:solidarity_app/domain/user/user_settings.dart';
import 'package:solidarity_app/infrastructure/user/user_local_repository.dart';
import 'package:solidarity_app/infrastructure/user/user_repository.dart';

class UserFactory implements UserRepositoryBase{

  UserFactory._();
  static UserFactory? _instance;
  static UserFactory get instance{
    if(_instance == null){
      _instance = UserFactory._();
    }
    return _instance!;
  }

  UserRepository userRepo = UserRepository();
  UserLocalRepository localUserRepo = UserLocalRepository();

  User? _loggedInUser;
  User? _selectedUser;

  User? get loggedInUser => _loggedInUser;
  User? get selectedUser => _selectedUser;

  void setLoggedInUser(User user){
    _loggedInUser = user;
  }

  void setSelectedUser(User user){
    _selectedUser = user;
  }

  @override
  Future<Result<User>> createNewUser(User user)async {
    Result<User> result = await userRepo.createNewUser(user);
    if(result.success && result.value!=null){
      _loggedInUser = result.value;
    }
    return result;
  }

  @override
  Future<Result<User>> getUser(String uid)async {
    return await userRepo.getUser(uid);
  }

  @override
  Future<Result<User>> removeUser(User user)async {
    return await userRepo.removeUser(user);
  }

  @override
  Future<Result<List<User>>> getAllUsers() async{
    return await userRepo.getAllUsers();
  }

  @override
  Future<Result<User>> saveUser(User user)async {
    return await userRepo.saveUser(user);
  }

  @override
  Future<Result<UserSettings>> getUserSettings()async {
    return await localUserRepo.getUserSettings();
  }

  @override
  Future<Result<UserSettings>> saveUserSettings(UserSettings settings)async {
    return await localUserRepo.saveUserSettings(settings);
  }

}