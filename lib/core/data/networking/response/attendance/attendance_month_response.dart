import '../../../model/attendance.dart';

class AttendanceMonthResponse {
  final List<Attendance> attendances;
  final bool error;
  final String message;

  AttendanceMonthResponse({
    required this.attendances,
    required this.error,
    required this.message,
  });

  factory AttendanceMonthResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceMonthResponse(
        attendances: List<Attendance>.from(
          json["attendances"].map((x) => Attendance.fromJson(x)),
        ),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "attendances": List<dynamic>.from(attendances.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}


