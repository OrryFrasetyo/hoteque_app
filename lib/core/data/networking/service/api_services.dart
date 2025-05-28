import 'dart:convert';
import 'dart:io';

import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/attendance_by_status_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/attendance_month_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/attendance_now_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/attendance_three_days_ago_response.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/clock_in_out_attendance_response.dart';
import 'package:hoteque_app/core/data/networking/response/profile_employee_response.dart';
import 'package:hoteque_app/core/data/networking/response/position_response.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/add_schedule_response.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/employee_in_department_response.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/schedule_employee_response.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/schedule_today_employee_response.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/schedule_department_employee_response.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/update_schedule_response.dart';
import 'package:hoteque_app/core/data/networking/response/shift/shift_response.dart';
import 'package:hoteque_app/core/data/networking/response/simple_response.dart';
import 'package:hoteque_app/core/data/networking/response/login_response.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class ApiServices {
  static const String _baseUrl = "http://192.168.1.15:3000/api";

  final http.Client httpClient;

  ApiServices({required this.httpClient});

  Future<ApiResponse<SimpleResponse>> register(Employee employee) async {
    return await executeSafely(() async {
      final response = await httpClient.post(
        Uri.parse("$_baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": employee.name,
          "email": employee.email,
          "password": employee.password,
          "phone": employee.phone,
          "position": employee.position,
        }),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SimpleResponse.fromJson(json);
      } else {
        final message = json["message"] ?? "Unknown error occurred";
        throw Exception(message);
      }
    });
  }

  Future<ApiResponse<LoginResponse>> login(
    String email,
    String password,
  ) async {
    return await executeSafely(() async {
      final response = await httpClient.post(
        Uri.parse("$_baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(json);
      } else {
        final errorMsg = json["message"] ?? "Login Failed";
        throw Exception(errorMsg);
      }
    });
  }

  Future<ApiResponse<PositionResponse>> getAllPositions() async {
    return await executeSafely(() async {
      final response = await httpClient.get(Uri.parse("$_baseUrl/positions"));
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return PositionResponse.fromJson(json);
      } else {
        final message = json["message"] ?? "Failed to fetch positions";
        throw Exception(message);
      }
    });
  }

  Future<ApiResponse<ProfileEmployeeResponse>> getProfile({
    required Employee employee,
  }) async {
    return await executeSafely(() async {
      final uri = Uri.parse("$_baseUrl/user");
      final response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
      );

      if (response.statusCode == 200) {
        return ProfileEmployeeResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to get data employee. Status code: ${response.statusCode}',
        );
      }
    });
  }

  Future<ApiResponse<ProfileEmployeeResponse>> updateProfile({
    required Employee employee,
    required String name,
    required String phone,
    String? password,
    File? photoFile,
  }) async {
    return await executeSafely(() async {
      final uri = Uri.parse("$_baseUrl/user");
      final request = http.MultipartRequest("PUT", uri);

      request.headers.addAll({"Authorization": "Bearer ${employee.token}"});

      request.fields["name"] = name;
      request.fields["phone"] = phone;

      if (password != null && password.isNotEmpty) {
        request.fields["password"] = password;
      }

      if (photoFile != null) {
        final fileExtension = path.extension(photoFile.path).toLowerCase();
        final mimeType = MediaType('image', _getImageMimeType(fileExtension));

        final photoStream = http.ByteStream(photoFile.openRead());
        final photoLength = await photoFile.length();

        final multipart = http.MultipartFile(
          'photo',
          photoStream,
          photoLength,
          filename: path.basename(photoFile.path),
          contentType: mimeType,
        );

        request.files.add(multipart);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProfileEmployeeResponse.fromJson(jsonDecode(response.body));
      } else {
        final json = jsonDecode(response.body);
        final message = json["message"] ?? "Failed to update profile";
        throw Exception(message);
      }
    });
  }

  String _getImageMimeType(String extension) {
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'jpeg';
      case '.png':
        return 'png';
      case '.gif':
        return 'gif';
      default:
        return 'jpeg';
    }
  }

  // schedule api services
  Future<ApiResponse<ScheduleEmployeeResponse>> getAllScheduleEmployee({
    required Employee employee,
  }) async {
    return await executeSafely(() async {
      final uri = Uri.parse("$_baseUrl/schedules");
      final response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
      );

      if (response.statusCode == 200) {
        return ScheduleEmployeeResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to get schedule. Status code: ${response.statusCode}',
        );
      }
    });
  }

  Future<ApiResponse<ScheduleTodayEmployeeResponse>> getScheduleNowEmployee({
    required Employee employee,
  }) async {
    return await executeSafely(() async {
      final uri = Uri.parse("$_baseUrl/schedules/today");
      final response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
      );

      if (response.statusCode == 200) {
        return ScheduleTodayEmployeeResponse.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception(
          'Failed to get schedule now. Status code: ${response.statusCode}',
        );
      }
    });
  }

  Future<ApiResponse<ScheduleDepartmentEmployeeResponse>>
  getScheduleDepartment({
    required Employee employee,
    required String date,
  }) async {
    return await executeSafely(() async {
      final queryParams = {'date': date};
      final uri = Uri.parse(
        "$_baseUrl/schedules/department",
      ).replace(queryParameters: queryParams);

      final response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
      );

      if (response.statusCode == 200) {
        return ScheduleDepartmentEmployeeResponse.fromJson(
          jsonDecode(response.body),
        );
      } else {
        final json = jsonDecode(response.body);
        final message = json["message"] ?? "Failed to get department schedule";
        throw Exception(message);
      }
    });
  }

  Future<ApiResponse<EmployeeInDepartmentResponse>> getAllEmployeeDepartment({
    required Employee employee,
  }) async {
    return await executeSafely(() async {
      final response = await httpClient.get(
        Uri.parse("$_baseUrl/employees"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
      );
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return EmployeeInDepartmentResponse.fromJson(json);
      } else {
        final message = json["message"] ?? "Failed to fetch employees";
        throw Exception(message);
      }
    });
  }

  Future<ApiResponse<AddScheduleResponse>> createScheduleEmployee({
    required Employee employee,
    required int employeeId,
    required int shiftId,
    required String dateSchedule,
    required String status,
  }) async {
    return await executeSafely(() async {
      final Map<String, dynamic> data = {
        "employee_id": employeeId,
        "shift_id": shiftId,
        "date_schedule": dateSchedule,
        "status": status,
      };

      final response = await httpClient.post(
        Uri.parse("$_baseUrl/schedules"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${employee.token}",
        },
        body: jsonEncode(data),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AddScheduleResponse.fromJson(json);
      } else {
        final message = json["message"] ?? "Gagal membuat jadwal";
        throw Exception(message);
      }
    });
  }

  Future<ApiResponse<UpdateScheduleResponse>> updateScheduleEmployee({
    required Employee employee,
    required int scheduleId,
    required int shiftId,
    required String dateSchedule,
    String? status,
  }) async {
    return await executeSafely(() async {
      final Map<String, dynamic> data = {
        "shift_id": shiftId,
        "date_schedule": dateSchedule,
      };

      if (status != null) {
        data["status"] = status;
      }

      final response = await httpClient.put(
        Uri.parse("$_baseUrl/schedules/$scheduleId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${employee.token}",
        },
        body: jsonEncode(data),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UpdateScheduleResponse.fromJson(json);
      } else {
        final message = json["message"] ?? "Gagal mengupdate jadwal.";
        throw Exception(message);
      }
    });
  }

  Future<ApiResponse<SimpleResponse>> deleteScheduleEmployee({
    required Employee employee,
    required int scheduleId,
  }) async {
    return await executeSafely(() async {
      final response = await httpClient.delete(
        Uri.parse("$_baseUrl/schedules/$scheduleId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${employee.token}",
        },
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SimpleResponse.fromJson(json);
      } else {
        final message = json["message"] ?? "Gagal hapus jadwal.";
        throw Exception(message);
      }
    });
  }

  Future<ApiResponse<ShiftResponse>> getAllShifts() async {
    return await executeSafely(() async {
      final response = await httpClient.get(Uri.parse("$_baseUrl/shifts"));
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ShiftResponse.fromJson(json);
      } else {
        final message = json["message"] ?? "Failed to fetch shifts";
        throw Exception(message);
      }
    });
  }

  Future<ApiResponse<AttendanceNowResponse>> getAttendanceNow({
    required Employee employee,
  }) async {
    return await executeSafely(() async {
      final uri = Uri.parse("$_baseUrl/attendance/today");
      final response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
      );

      if (response.statusCode == 200) {
        return AttendanceNowResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to get attendance now. Status code: ${response.statusCode}',
        );
      }
    });
  }

  Future<ApiResponse<ClockInOutAttendanceResponse>> clockInAttendance({
    required Employee employee,
    required String clockIn,
  }) async {
    return await executeSafely(() async {
      final uri = Uri.parse("$_baseUrl/attendance");
      final response = await httpClient.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
        body: jsonEncode({"clock_in": clockIn}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ClockInOutAttendanceResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to clock in attendance now. Status code: ${response.statusCode}',
        );
      }
    });
  }

  Future<ApiResponse<ClockInOutAttendanceResponse>> clockOutAttendance({
    required Employee employee,
    required String clockOut,
  }) async {
    return await executeSafely(() async {
      final uri = Uri.parse("$_baseUrl/attendance");
      final response = await httpClient.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
        body: jsonEncode({"clock_out": clockOut}),
      );

      if (response.statusCode == 200) {
        return ClockInOutAttendanceResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to clock out attendance now. Status code: ${response.statusCode}',
        );
      }
    });
  }

  Future<ApiResponse<AttendanceThreeDaysAgoResponse>>
  getAttendanceThreeDaysAgo({required Employee employee}) async {
    return await executeSafely(() async {
      final uri = Uri.parse("$_baseUrl/attendance");
      final response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
      );

      if (response.statusCode == 200) {
        return AttendanceThreeDaysAgoResponse.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception(
          'Failed to get attendance 3 days ago. Status code: ${response.statusCode}',
        );
      }
    });
  }

  Future<ApiResponse<AttendanceMonthResponse>> getAttendanceMonth({
    required Employee employee,
  }) async {
    return await executeSafely(() async {
      final uri = Uri.parse("$_baseUrl/attendance/month");
      final response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
      );

      if (response.statusCode == 200) {
        return AttendanceMonthResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to get attendance month. Status code: ${response.statusCode}',
        );
      }
    });
  }

  Future<ApiResponse<AttendanceByStatusResponse>> getAttendanceByStatus({
    required Employee employee,
    String? clockInStatus,
    String? clockOutStatus,
  }) async {
    return await executeSafely(() async {
      final queryParams = <String, String>{};
      
      if (clockInStatus != null) {
        queryParams['clock_in_status'] = clockInStatus;
      }
      
      if (clockOutStatus != null) {
        queryParams['clock_out_status'] = clockOutStatus;
      }

      final uri = Uri.parse("$_baseUrl/attendance/status?").replace(queryParameters: queryParams);
      final response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${employee.token}',
        },
      );

      if (response.statusCode == 200) {
        return AttendanceByStatusResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to get attendance by status. Status code: ${response.statusCode}',
        );
      }
    });
  }
}
