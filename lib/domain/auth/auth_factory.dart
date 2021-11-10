
import 'package:solidarity_app/domain/auth/auth_repository_base.dart';
import 'package:solidarity_app/domain/core/general_factory.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';
import 'package:solidarity_app/infrastructure/auth/auth_repository.dart';
import 'package:solidarity_app/infrastructure/core/general_repository.dart';
import 'package:solidarity_app/infrastructure/user/user_repository.dart';

class AuthFactory implements AuthRepositoryBase{

  AuthFactory._();

  static AuthFactory get instance {
    if(_instance==null) _instance = AuthFactory._();
    return _instance!;
  }

  static AuthFactory? _instance;

  AuthRepository authRepo = AuthRepository() ;

  UserFactory userRepo = UserFactory.instance;
  GeneralFactory generalRep = GeneralFactory.instance;


  @override
  Future<Result<User>> signInUser(String code)async{
    ///First validate the code
    Result<String> memberType = await generalRep.getMembershipCode(code);
    if(!memberType.success)
      return Result(null,success: false,userMessage: memberType.userMessage);

    Result<User> authUser = await authRepo.signInUser(memberType.value!);
    if(authUser.success){
      ///user obtained..now check if he's already signed up
      Result<User> signedInUser = await userRepo.getUser(authUser.value!.uid!);
      if(signedInUser.success || (!signedInUser.success && signedInUser.errorCode==ErrorCodes.NO_USER)){
        if(signedInUser.value!=null){
          ///User exists in server..so return that user
          userRepo.setLoggedInUser(signedInUser.value!);
          return signedInUser;
        }else{
          ///User does not exist. so create a new one
          Result<User> newUser = await userRepo.createNewUser(authUser.value!);
          return newUser;
        }
      }
      ///An error occurred
      return signedInUser;
    }

    return authUser;
  }


  Future<Result<User>> getLoggedInUser()async{
     Result<User> localUser = await authRepo.getLoggedInUser();
     if(localUser.value!=null){
       print('user already logged in');
       ///now get from server
       Result<User> user = await userRepo.getUser(localUser.value!.uid!);
      // print('uid ${localUser.value!.uid!} ${user.message}');
       if(user.value==null){
         if(user.errorCode==ErrorCodes.NO_USER){
           ///logout local instance
           Result<bool> loggedout = await authRepo.logOutUser();
           if(loggedout.success){
           //  print('user logged out!!');
             return Result(null,userMessage: 'This user does not exist!', success: false);
           }else{
             return Result(null, success: false, userMessage: loggedout.userMessage);
           }
         }
       }

       ///set currently loggedin user
       userRepo.setLoggedInUser(user.value!);

       return user;
     }
    // print('user not already logged in');
     return localUser;
  }

  @override
  Future<Result<bool>> logOutUser() async{
    return authRepo.logOutUser();
  }

}