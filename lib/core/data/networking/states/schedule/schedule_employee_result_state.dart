import 'package:hoteque_app/core/data/model/schedule_employee.dart';

sealed class ScheduleEmployeeResultState {}

class ScheduleEmployeeInitialState extends ScheduleEmployeeResultState {}

class ScheduleEmployeeLoadingState extends ScheduleEmployeeResultState {}

class ScheduleEmployeeErrorState extends ScheduleEmployeeResultState {
  final String message;
  
  ScheduleEmployeeErrorState(this.message);
}

class ScheduleEmployeeLoadedState extends ScheduleEmployeeResultState {
  final List<ScheduleEmployee> schedules;
  
  ScheduleEmployeeLoadedState(this.schedules);
}
