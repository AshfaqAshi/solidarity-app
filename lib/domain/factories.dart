
import 'package:solidarity_app/domain/auth/auth_factory.dart';
import 'package:solidarity_app/domain/core/general_factory.dart';
import 'package:solidarity_app/domain/unit/unit_factory.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';

import 'area/area_factory.dart';

class Factories{
  static AuthFactory authFactory = AuthFactory.instance;
  static UserFactory userFactory = UserFactory.instance;
  static UnitFactory unitFactory = UnitFactory.instance;
  static AreaFactory areaFactory = AreaFactory.instance;
  static GeneralFactory generalFactory = GeneralFactory.instance;
}