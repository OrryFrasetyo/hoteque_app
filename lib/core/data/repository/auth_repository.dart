import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/simple_response.dart';
import 'package:hoteque_app/core/data/networking/response/login_response.dart';
import 'package:hoteque_app/core/data/networking/service/api_services.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final SharedPreferences _sharedPref;
  final ApiServices _apiServices;

  AuthRepository(this._sharedPref, this._apiServices);

  final String stateKey = "state";
  final String employeeKey = "employee";
  final String firstLaunchKey = "first_launch";

  Future<bool> isFirstLaunch() async {
    return _sharedPref.getBool(firstLaunchKey) ?? true;
  }

  Future<void> markFirstLaunchComplete() async {
    await _sharedPref.setBool(firstLaunchKey, false);
  }

  Future<bool> isLoggedIn() async {
    return _sharedPref.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    return _sharedPref.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    return _sharedPref.setBool(stateKey, false);
  }

  Future<bool> saveEmployee(Employee employee) async {
    return _sharedPref.setString(employeeKey, employee.toJson());
  }

  Future<bool> deleteEmployee() async {
    return _sharedPref.setString(employeeKey, "");
  }

  Future<Employee?> getEmployee() async {
    await Future.delayed(Duration(seconds: 2));
    final json = _sharedPref.getString(employeeKey) ?? "";
    Employee? employee;
    try {
      employee = Employee.fromJson(json);
    } catch (e) {
      employee = null;
    }
    return employee;
  }

  Future<ApiResponse<SimpleResponse>> register(Employee employee) async {
    final response = await _apiServices.register(employee);
    if (response.data != null && !response.data!.error) {
      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? "Unknown error occurred");
  }

  Future<ApiResponse<LoginResponse>> loginEmployee(
    String email,
    String password,
  ) async {
    final response = await _apiServices.login(email, password);
    if (response.data != null && !response.data!.error) {
      final employee = Employee(
        email: email,
        name: response.data!.loginResult.name,
        password: password,
        token: response.data!.loginResult.token,
      );

      await saveEmployee(employee);
      await login();

      return ApiResponse.success(response.data!);
    }
    return ApiResponse.error(response.message ?? "Unknown error occurred");
  }
}
