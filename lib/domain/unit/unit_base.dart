
import 'package:solidarity_app/domain/core/result.dart';
import 'package:solidarity_app/domain/unit/unit.dart';

abstract class UnitBase{
  Future<Result<List<Unit>>> getUnits(String areaId);
  ///[getUnitDetails]
  ///Gets the Referenced data like President, Secretary, etc. for the
  ///given Unit
  Future<Result<Unit>> getUnitDetails(Unit unit);
  Future<Result<Unit>> addNewUnit(Unit unit);
  Future<Result<Unit>> updateUnit(Unit unit);
  Future<Result<Unit>> removeUnit(Unit unit);
  ///[getUnit]
  ///Gets the Base Unit data
  Future<Result<Unit>> getUnit(String unitId, String areaId);
}