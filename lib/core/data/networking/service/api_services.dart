import 'dart:convert';

import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/simple_response.dart';
import 'package:hoteque_app/core/data/networking/response/login_response.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String _baseUrl = "http://192.168.100.134:3000/api";
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
}
