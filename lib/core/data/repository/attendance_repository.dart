import 'package:hoteque_app/core/data/networking/response/attendance/attendance_month_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/attendance_now_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/attendance_three_days_ago_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/clock_in_attendance_response.dart';
import 'package:hoteque_app/core/data/networking/service/api_services.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';

import '../model/employee.dart';

class AttendanceRepository {
  final ApiServices _apiServices;

  AttendanceRepository(this._apiServices);

  Future<ApiResponse<AttendanceNowResponse>> getAttendanceNow({
    required Employee employee,
  }) async {
    return await _apiServices.getAttendanceNow(employee: employee);
  }

  Future<ApiResponse<AttendanceThreeDaysAgoResponse>>
  getAttendanceThreeDaysAgo({required Employee employee}) async {
    return await _apiServices.getAttendanceThreeDaysAgo(employee: employee);
  }

  Future<ApiResponse<AttendanceMonthResponse>> getAttendanceMonth({
    required Employee employee,
  }) async {
    return await _apiServices.getAttendanceMonth(employee: employee);
  }

  Future<ApiResponse<ClockInAttendanceResponse>> clockInAttendance({
    required Employee employee,
    required String clockIn,
  }) async {
    return await _apiServices.clockInAttendance(
      employee: employee,
      clockIn: clockIn,
    );
  }
}
