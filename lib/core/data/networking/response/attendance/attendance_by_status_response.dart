class AttendanceByStatusResponse {
  final List<AttendanceStatus> attendances;
  final bool error;
  final String message;

  AttendanceByStatusResponse({
    required this.attendances,
    required this.error,
    required this.message,
  });

  factory AttendanceByStatusResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceByStatusResponse(
        attendances: List<AttendanceStatus>.from(
          json["attendances"].map((x) => AttendanceStatus.fromJson(x)),
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

class AttendanceStatus {
  final String clockIn;
  final String clockInStatus;
  final String clockOut;
  final String clockOutStatus;
  final DateTime createdAt;
  final DateTime date;
  final String duration;
  final int id;
  final DateTime updatedAt;

  AttendanceStatus({
    required this.clockIn,
    required this.clockInStatus,
    required this.clockOut,
    required this.clockOutStatus,
    required this.createdAt,
    required this.date,
    required this.duration,
    required this.id,
    required this.updatedAt,
  });

  factory AttendanceStatus.fromJson(Map<String, dynamic> json) => AttendanceStatus(
    clockIn: json["clock_in"],
    clockInStatus: json["clock_in_status"],
    clockOut: json["clock_out"],
    clockOutStatus: json["clock_out_status"],
    createdAt: DateTime.parse(json["created_at"]),
    date: DateTime.parse(json["date"]),
    duration: json["duration"],
    id: json["id"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "clock_in": clockIn,
    "clock_in_status": clockInStatus,
    "clock_out": clockOut,
    "clock_out_status": clockOutStatus,
    "created_at": createdAt.toIso8601String(),
    "date": date.toIso8601String(),
    "duration": duration,
    "id": id,
    "updated_at": updatedAt.toIso8601String(),
  };
}
