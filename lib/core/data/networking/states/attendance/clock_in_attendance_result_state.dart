import '../../response/attendance/clock_in_attendance_response.dart';

sealed class ClockInAttendanceResultState {}

class ClockInAttendanceInitialState extends ClockInAttendanceResultState {}

class ClockInAttendanceLoadingState extends ClockInAttendanceResultState {}

class ClockInAttendanceSuccessState extends ClockInAttendanceResultState {
  final ClockInAttendanceResponse response;
  
  ClockInAttendanceSuccessState(this.response);
}

class ClockInAttendanceErrorState extends ClockInAttendanceResultState {
  final String message;
  
  ClockInAttendanceErrorState(this.message);
}