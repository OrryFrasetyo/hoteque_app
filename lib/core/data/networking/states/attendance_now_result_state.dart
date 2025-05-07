import 'package:hoteque_app/core/data/networking/response/attendance/attendance_now_response.dart';

sealed class AttendanceNowResultState {}

class AttendanceNowInitialState extends AttendanceNowResultState {}

class AttendanceNowLoadingState extends AttendanceNowResultState {}

class AttendanceNowErrorState extends AttendanceNowResultState {
  final String message;

  AttendanceNowErrorState(this.message);
}

class AttendanceNowLoadedState extends AttendanceNowResultState {
  final AttendanceNow attendanceNow;

  AttendanceNowLoadedState(this.attendanceNow);
}
