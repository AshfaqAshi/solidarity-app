import 'package:solidarity_app/domain/core/membership_code.dart';
import 'package:solidarity_app/domain/core/result.dart';

abstract class GeneralRepositoryBase{
  Future<Result<String>> getMembershipCode(String code);
  Future<Result<List<MembershipCode>>> getAllMembershipCodes();
}