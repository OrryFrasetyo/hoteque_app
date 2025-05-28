import 'package:hoteque_app/core/data/networking/response/attendance/attendance_by_status_response.dart';

sealed class AttendanceByStatusResultState {}

class AttendanceByStatusInitialState extends AttendanceByStatusResultState {}

class AttendanceByStatusLoadingState extends AttendanceByStatusResultState {}

class AttendanceByStatusErrorState extends AttendanceByStatusResultState {
  final String message;

  AttendanceByStatusErrorState(this.message);
}

class AttendanceByStatusLoadedState extends AttendanceByStatusResultState {
  final List<AttendanceStatus> attendances;

  AttendanceByStatusLoadedState(this.attendances);
}