import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarity_app/domain/core/general_repository_base.dart';
import 'package:solidarity_app/domain/core/membership_code.dart';
import 'package:solidarity_app/domain/core/result.dart';

class GeneralRepository implements GeneralRepositoryBase{
  @override
  Future<Result<String>> getMembershipCode(String code) async{
    try{
      DocumentSnapshot<Map<String,dynamic>> orgDoc = await GeneralRepository.getOrgDoc().get();
      if(orgDoc.exists){
        Map<String,dynamic> membershipCodes = orgDoc.data()!['membershipCodes'];
        //print('memcode $membershipCodes and code $code');
        if(membershipCodes.containsKey(code)){
          return Result(membershipCodes[code]);
        }else{
          return Result(null,success: false,userMessage: 'This Membership Code is invalid');
        }
      }
      return Result(null,success: false,message: 'This organisation does not exist!');
    }catch(ex){
      //print('error getting memcode ${ex.toString()}');
      return Result(null,success: false,userMessage: 'Failed to validate your Membership code',
      message: ex.toString());
    }
  }

  static DocumentReference<Map<String,dynamic>> getOrgDoc(){
    return  FirebaseFirestore.instance.collection(Collection.ORG).doc(Docs.SOLIDARITY);
  }

  @override
  Future<Result<List<MembershipCode>>> getAllMembershipCodes() async{
    try{
      DocumentSnapshot<Map<String,dynamic>> orgDoc = await GeneralRepository.getOrgDoc().get();
      if(orgDoc.exists){
        Map<String,dynamic>? membershipCodes = orgDoc.data()!['membershipCodes'];
        if(membershipCodes!=null){
          List<MembershipCode> _codes=[];
          membershipCodes.forEach((key, value) {
            _codes.add(MembershipCode(value, key));
          });
          return Result(_codes);
        }else{
          return Result(null,userMessage: 'No Membership Code found');
        }
      }
      return Result(null,success: false,userMessage: 'This organisation does not exist!');
    }catch(ex){
      //print('error getting memcode ${ex.toString()}');
      return Result(null,success: false,userMessage: 'Failed to validate your Membership code',
          message: ex.toString());
    }
  }

}

class Collection{
  static const String ORG='org';
  static const String USERS='users';
  static const String REPORTS='reports';
  static const String UNITS='units';
  static const String AREAS='areas';
}

class Docs{
  static const String SOLIDARITY='solidarity';
}