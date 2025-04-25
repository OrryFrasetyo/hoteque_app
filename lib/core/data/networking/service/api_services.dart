import 'dart:convert';
import 'dart:io';

import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/profile_employee_response.dart';
import 'package:hoteque_app/core/data/networking/response/position_response.dart';
import 'package:hoteque_app/core/data/networking/response/simple_response.dart';
import 'package:hoteque_app/core/data/networking/response/login_response.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class ApiServices {
  static const String _baseUrl = "http://192.168.80.233:3000/api";
  // static const String _baseUrl = "http://192.168.100.134:3000/api";
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
}
