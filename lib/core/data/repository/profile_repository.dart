import 'dart:io';

import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/profile_employee_response.dart';
import 'package:hoteque_app/core/data/networking/service/api_services.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';

class ProfileRepository {
  final ApiServices _apiServices;

  ProfileRepository(this._apiServices);

  Future<ApiResponse<ProfileEmployeeResponse>> getProfile({
    required Employee employee,
  }) async {
    return await _apiServices.getProfile(employee: employee);
  }

  Future<ApiResponse<ProfileEmployeeResponse>> updateProfile({
    required Employee employee,
    required String name,
    required String phone,
    String? password,
    File? photoFile,
  }) async {
    return await _apiServices.updateProfile(
      employee: employee,
      name: name,
      phone: phone,
      password: password,
      photoFile: photoFile,
    );
  }
}
