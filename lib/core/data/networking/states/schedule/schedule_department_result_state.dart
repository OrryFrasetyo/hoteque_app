import 'package:hoteque_app/core/data/networking/response/schedule/schedule_department_employee_response.dart';

sealed class ScheduleDepartmentResultState {}

class ScheduleDepartmentInitialState extends ScheduleDepartmentResultState {}

class ScheduleDepartmentLoadingState extends ScheduleDepartmentResultState {}

class ScheduleDepartmentErrorState extends ScheduleDepartmentResultState {
  final String message;

  ScheduleDepartmentErrorState(this.message);
}

class ScheduleDepartmentLoadedState extends ScheduleDepartmentResultState {
  final List<Schedule> schedules;
  final Meta meta;

  ScheduleDepartmentLoadedState(this.schedules, this.meta);

}
