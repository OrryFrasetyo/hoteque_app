import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/add_schedule_response.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/employee_in_department_response.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/schedule_department_employee_response.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/schedule_employee_response.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/schedule_today_employee_response.dart';
import 'package:hoteque_app/core/data/networking/response/shift/shift_response.dart';
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

  Future<ApiResponse<ScheduleTodayEmployeeResponse>> getScheduleNowEmployee({
    required Employee employee,
  }) async {
    return await _apiServices.getScheduleNowEmployee(employee: employee);
  }

  Future<ApiResponse<ScheduleDepartmentEmployeeResponse>>
  getScheduleDepartment({
    required Employee employee,
    required String date,
  }) async {
    return await _apiServices.getScheduleDepartment(
      employee: employee,
      date: date,
    );
  }

  Future<ApiResponse<EmployeeInDepartmentResponse>> getAllEmployeeInDepartment({
    required Employee employee,
  }) async {
    return await _apiServices.getAllEmployeeDepartment(employee: employee);
  }

  Future<ApiResponse<AddScheduleResponse>> createScheduleEmployee({
    required Employee employee,
    required int employeeId,
    required int shiftId,
    required String dateSchedule,
    required String status,
  }) async {
    return await _apiServices.createScheduleEmployee(
      employee: employee,
      employeeId: employeeId,
      shiftId: shiftId,
      dateSchedule: dateSchedule,
      status: status,
    );
  }

  Future<ApiResponse<ShiftResponse>> getAllShift() async {
    return await _apiServices.getAllShifts();
  }
}
