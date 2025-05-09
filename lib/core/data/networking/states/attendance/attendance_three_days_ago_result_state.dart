import '../../../model/attendance.dart';

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
