import '../../../model/attendance.dart';

class AttendanceThreeDaysAgoResponse {
  final List<Attendance> attendance;
  final bool error;
  final String message;

  AttendanceThreeDaysAgoResponse({
    required this.attendance,
    required this.error,
    required this.message,
  });

  factory AttendanceThreeDaysAgoResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceThreeDaysAgoResponse(
        attendance: List<Attendance>.from(
          json["attendance"].map((x) => Attendance.fromJson(x)),
        ),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "attendance": List<dynamic>.from(attendance.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}


