import 'package:hoteque_app/core/data/networking/response/schedule/employee_in_department_response.dart';

sealed class GetEmployeeInDepartmentResultState {}

class GetEmployeeInDepartmentInitialState
    extends GetEmployeeInDepartmentResultState {}

class GetEmployeeInDepartmentLoadingState
    extends GetEmployeeInDepartmentResultState {}

class GetEmployeeInDepartmentErrorState
    extends GetEmployeeInDepartmentResultState {
  final String message;

  GetEmployeeInDepartmentErrorState(this.message);
}

class GetEmployeeInDepartmentLoadedState
    extends GetEmployeeInDepartmentResultState {
  final List<EmployeeSearch> employee;

  GetEmployeeInDepartmentLoadedState(this.employee);
}
