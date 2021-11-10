
import 'package:solidarity_app/domain/core/general_repository_base.dart';
import 'package:solidarity_app/domain/core/membership_code.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/infrastructure/core/general_repository.dart';

class GeneralFactory implements GeneralRepositoryBase{

  GeneralFactory._();

  static GeneralFactory get instance {
    if(_instance==null) _instance = GeneralFactory._();
    return _instance!;
  }

  static GeneralFactory? _instance;

  GeneralRepository generalRep = GeneralRepository();

  @override
  Future<Result<String>> getMembershipCode(String code) async{
    return  await generalRep.getMembershipCode(code);
  }

  @override
  Future<Result<List<MembershipCode>>> getAllMembershipCodes()async {
    return await generalRep.getAllMembershipCodes();
  }

}