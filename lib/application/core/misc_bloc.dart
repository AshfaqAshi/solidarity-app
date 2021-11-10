import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:solidarity_app/domain/core/general_factory.dart';
import 'package:solidarity_app/domain/core/membership_code.dart';
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/factories.dart';

part 'misc_event.dart';
part 'misc_state.dart';

class MiscBloc extends Bloc<MiscEvent, MiscState> {

  GeneralFactory generalFactory = Factories.generalFactory;

  MiscBloc() : super(MiscInitial());

  Stream<MiscState> mapEventToState(MiscEvent event)async*{
    if(event is GetAllMembershipCodesEvent){

      yield GetAllMembershipCodesState();
      var result = await generalFactory.getAllMembershipCodes();
      yield GetAllMembershipCodesCompleteState(result);
    }
  }
}
