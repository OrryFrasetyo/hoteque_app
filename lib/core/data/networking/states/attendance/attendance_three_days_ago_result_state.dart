import 'package:hoteque_app/core/data/networking/response/attendance/attendance_three_days_ago_response.dart';

sealed class AttendanceThreeDaysAgoResultState {}

class AttendanceThreeDaysAgoInitialState
    extends AttendanceThreeDaysAgoResultState {}

class AttendanceThreeDaysAgoLoadingState
    extends AttendanceThreeDaysAgoResultState {}

class AttendanceThreeDaysAgoErrorState
    extends AttendanceThreeDaysAgoResultState {
  final String message;

  AttendanceThreeDaysAgoErrorState(this.message);
}

class AttendanceThreeDaysAgoLoadedState
    extends AttendanceThreeDaysAgoResultState {
  final List<Attendance> attendances;

  AttendanceThreeDaysAgoLoadedState(this.attendances);
}
