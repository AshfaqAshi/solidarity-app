
import 'package:solidarity_app/domain/area/area.dart';
import 'package:solidarity_app/domain/core/result.dart';


abstract class AreaBase{
  Future<Result<List<Area>>> getAreas();
  ///[getAreaDetails]
  ///Gets the Referenced data like President, Secretary, etc. for the
  ///given Area
  Future<Result<Area>> getAreaDetails(Area area);
  Future<Result<Area>> addNewArea(Area area);
  Future<Result<Area>> updateArea(Area area);
  Future<Result<Area>> removeArea(Area area);
  ///[getArea]
  ///Gets the Base Area data
  Future<Result<Area>> getArea(String areaId);
}