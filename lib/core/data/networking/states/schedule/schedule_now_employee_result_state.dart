import 'package:hoteque_app/core/data/networking/response/schedule/schedule.dart';

sealed class ScheduleNowEmployeeResultState {}

class ScheduleNowEmployeeInitialState extends ScheduleNowEmployeeResultState {}

class ScheduleNowEmployeeLoadingState extends ScheduleNowEmployeeResultState {}

class ScheduleNowEmployeeErrorState extends ScheduleNowEmployeeResultState {
  final String message;
  
  ScheduleNowEmployeeErrorState(this.message);
}

class ScheduleNowEmployeeLoadedState extends ScheduleNowEmployeeResultState {
  final List<Schedule> schedules;
  
  ScheduleNowEmployeeLoadedState(this.schedules);
}
