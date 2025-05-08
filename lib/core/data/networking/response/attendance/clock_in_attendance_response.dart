class ClockInAttendanceResponse {
  final Attendance attendance;
  final bool error;
  final String message;

  ClockInAttendanceResponse({
    required this.attendance,
    required this.error,
    required this.message,
  });

  factory ClockInAttendanceResponse.fromJson(Map<String, dynamic> json) =>
      ClockInAttendanceResponse(
        attendance: Attendance.fromJson(json["attendance"]),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "attendance": attendance.toJson(),
    "error": error,
    "message": message,
  };
}

class Attendance {
  final String clockIn;
  final String clockInStatus;
  final String clockOut;
  final String clockOutStatus;
  final DateTime createdAt;
  final DateTime date;
  final String duration;
  final EmployeeClockIn employee;
  final int id;
  final Schedule schedule;
  final DateTime updatedAt;

  Attendance({
    required this.clockIn,
    required this.clockInStatus,
    required this.clockOut,
    required this.clockOutStatus,
    required this.createdAt,
    required this.date,
    required this.duration,
    required this.employee,
    required this.id,
    required this.schedule,
    required this.updatedAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    clockIn: json["clock_in"],
    clockInStatus: json["clock_in_status"],
    clockOut: json["clock_out"],
    clockOutStatus: json["clock_out_status"],
    createdAt: DateTime.parse(json["created_at"]),
    date: DateTime.parse(json["date"]),
    duration: json["duration"],
    employee: EmployeeClockIn.fromJson(json["employee"]),
    id: json["id"],
    schedule: Schedule.fromJson(json["schedule"]),
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
    "employee": employee.toJson(),
    "id": id,
    "schedule": schedule.toJson(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class EmployeeClockIn {
  final int id;
  final String name;
  final String position;

  EmployeeClockIn({required this.id, required this.name, required this.position});

  factory EmployeeClockIn.fromJson(Map<String, dynamic> json) =>
      EmployeeClockIn(id: json["id"], name: json["name"], position: json["position"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "position": position,
  };
}

class Schedule {
  final DateTime dateSchedule;
  final int id;
  final String status;

  Schedule({
    required this.dateSchedule,
    required this.id,
    required this.status,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    dateSchedule: DateTime.parse(json["date_schedule"]),
    id: json["id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "date_schedule": dateSchedule.toIso8601String(),
    "id": id,
    "status": status,
  };
}
