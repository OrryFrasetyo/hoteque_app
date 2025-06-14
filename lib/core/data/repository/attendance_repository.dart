import 'package:hoteque_app/core/data/networking/response/attendance/attendance_by_status_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/attendance_month_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/attendance_now_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/attendance_three_days_ago_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/clock_in_out_attendance_response.dart';
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

  Future<ApiResponse<ClockInOutAttendanceResponse>> clockInAttendance({
    required Employee employee,
    required String clockIn,
  }) async {
    return await _apiServices.clockInAttendance(
      employee: employee,
      clockIn: clockIn,
    );
  }

  Future<ApiResponse<ClockInOutAttendanceResponse>> clockOutAttendance({
    required Employee employee,
    required String clockOut,
  }) async {
    return await _apiServices.clockOutAttendance(
      employee: employee,
      clockOut: clockOut,
    );
  }

  Future<ApiResponse<AttendanceByStatusResponse>> getAttendanceByStatus({
    required Employee employee,
    String? clockInStatus,
    String? clockOutStatus,
  }) async {
    return await _apiServices.getAttendanceByStatus(
      employee: employee,
      clockInStatus: clockInStatus,
      clockOutStatus: clockOutStatus,
    );
  }
}
