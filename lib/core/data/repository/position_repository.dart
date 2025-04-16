import 'package:hoteque_app/core/data/networking/response/position_response.dart';
import 'package:hoteque_app/core/data/networking/service/api_services.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';

class PositionRepository {
  final ApiServices _apiServices;

  PositionRepository(this._apiServices);

  Future<ApiResponse<PositionResponse>> getAllPositions() async {
    return await _apiServices.getAllPositions();
  }
}
