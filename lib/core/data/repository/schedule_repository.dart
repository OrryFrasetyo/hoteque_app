import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/schedule_employee_response.dart';
import 'package:hoteque_app/core/data/networking/service/api_services.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';

class ScheduleRepository {
  final ApiServices _apiServices;

  ScheduleRepository(this._apiServices);

  Future<ApiResponse<ScheduleEmployeeResponse>> getAllScheduleEmployee({
    required Employee employee,
  }) async {
    return await _apiServices.getAllScheduleEmployee(employee: employee);
  }
}