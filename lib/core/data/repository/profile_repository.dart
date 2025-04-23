import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/get_profile_employee_response.dart';
import 'package:hoteque_app/core/data/networking/service/api_services.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';

class ProfileRepository {
  final ApiServices _apiServices;

  ProfileRepository(this._apiServices);

  Future<ApiResponse<GetProfileEmployeeResponse>> getProfile ({
    required Employee employee,
  }) async {
    return await _apiServices.getProfile(employee: employee);
  }

}