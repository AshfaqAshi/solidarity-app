
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:solidarity_app/domain/auth/auth_repository_base.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:solidarity_app/infrastructure/user/user_repository.dart';
import 'package:solidarity_app/presentation/core/helper.dart';

class AuthRepository implements AuthRepositoryBase{


  GoogleSignIn? googleSignIn=GoogleSignIn();


  @override
  Future<Result<User>> signInUser(String code)async{
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn!.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = Auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      Auth.UserCredential userCred =  await Auth.FirebaseAuth.instance.signInWithCredential(credential);
      User user = User(
        designation: code,
        field: Helper.getUserFieldFromDesignation(code),
        name: userCred.user!.displayName,
        phone: userCred.user!.phoneNumber
      );
      user.uid = userCred.user!.uid;

      return Result(user);
    }catch(ex, stack){
      print('error ${ex.toString()}');
      print('stack ${stack.toString()}');
      return Result(null,message: ex.toString(),userMessage: 'An error occurred while trying to sign in',success: false);
    }

  }

  @override
  Future<Result<User>> getLoggedInUser()async{
    if(Auth.FirebaseAuth.instance.currentUser==null){
      return Result(null);
    }else{
      User user = User(field: '', designation: '');
      user.uid = Auth.FirebaseAuth.instance.currentUser!.uid;
      return Result(user);
    }
  }

  @override
  Future<Result<bool>> logOutUser()async{
    // TODO: implement logOutUser
    try{
      await googleSignIn!.signOut();
      await Auth.FirebaseAuth.instance.signOut();
      return Result(true);
    }catch(ex){
      return Result(null,message: ex.toString(),userMessage: 'An error occurred while trying to sign out',success: false);
    }
  }

}