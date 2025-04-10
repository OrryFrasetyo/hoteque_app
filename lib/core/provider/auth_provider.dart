import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/login_response.dart';
import 'package:hoteque_app/core/data/networking/response/simple_response.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';
import 'package:hoteque_app/core/data/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  Employee? employee;
  String errorMsg = "";

  Future<bool> isLogged() async {
    isLoggedIn = await authRepository.isLoggedIn();
    return isLoggedIn;
  }

  Future<ApiResponse<SimpleResponse>> register(Employee employee) async {
    isLoadingRegister = true;
    notifyListeners();

    final response = await authRepository.register(employee);

    isLoadingRegister = false;
    notifyListeners();

    return response;
  }

  Future<ApiResponse<LoginResponse>> login(
    String email,
    String password,
  ) async {
    isLoadingLogin = true;
    notifyListeners();

    final response = await authRepository.loginEmployee(email, password);
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogin = false;
    notifyListeners();

    return response;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteEmployee();
    }
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }

  Future<bool> saveEmployee(Employee employee) async {
    isLoadingRegister = true;
    notifyListeners();

    final employeeState = await authRepository.saveEmployee(employee);

    isLoadingRegister = false;
    notifyListeners();

    return employeeState;
  }

  Future<void> getEmployee() async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      employee = await authRepository.getEmployee();
      if (employee == null) {
        errorMsg = "Employee not found";
      }
    } catch (e) {
      errorMsg = "Error occurred while fetching employee data";
    }

    isLoadingLogin = false;
    notifyListeners();
  }
}
