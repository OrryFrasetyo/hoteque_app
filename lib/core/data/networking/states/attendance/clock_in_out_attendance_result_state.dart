import '../../response/attendance/clock_in_out_attendance_response.dart';

sealed class ClockInOutAttendanceResultState {}

class ClockInOutAttendanceInitialState extends ClockInOutAttendanceResultState {}

class ClockInOutAttendanceLoadingState extends ClockInOutAttendanceResultState {}

class ClockInOutAttendanceSuccessState extends ClockInOutAttendanceResultState {
  final ClockInOutAttendanceResponse response;

  ClockInOutAttendanceSuccessState(this.response);
}

class ClockInOutAttendanceErrorState extends ClockInOutAttendanceResultState {
  final String message;

  ClockInOutAttendanceErrorState(this.message);
}
