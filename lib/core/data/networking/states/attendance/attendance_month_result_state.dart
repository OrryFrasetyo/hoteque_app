import '../../../model/attendance.dart';

sealed class AttendanceMonthResultState {}

class AttendanceMonthInitialState extends AttendanceMonthResultState {}

class AttendanceMonthLoadingState extends AttendanceMonthResultState {}

class AttendanceMonthErrorState extends AttendanceMonthResultState {
  final String message;

  AttendanceMonthErrorState(this.message);
}

class AttendanceMonthLoadedState extends AttendanceMonthResultState {
  final List<Attendance> attendances;

  AttendanceMonthLoadedState(this.attendances);
}
