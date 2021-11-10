part of 'misc_bloc.dart';

@immutable
abstract class MiscState {}

class MiscInitial extends MiscState {}

class GetAllMembershipCodesState extends MiscState{}

class GetAllMembershipCodesCompleteState extends MiscState{
  final Result<List<MembershipCode>> result;
  GetAllMembershipCodesCompleteState(this.result);
}

