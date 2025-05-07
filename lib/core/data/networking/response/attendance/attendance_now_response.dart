class AttendanceNowResponse {
  final AttendanceNow attendanceNow;
  final bool error;
  final String message;

  AttendanceNowResponse({
    required this.attendanceNow,
    required this.error,
    required this.message,
  });

  factory AttendanceNowResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceNowResponse(
        attendanceNow: AttendanceNow.fromJson(json["attendance_now"]),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "attendance_now": attendanceNow.toJson(),
    "error": error,
    "message": message,
  };
}

class AttendanceNow {
  final int id;
  final EmployeeAttendance employee;
  final Schedule schedule;
  final DateTime date;
  final String clockIn;
  final String clockOut;
  final String duration;
  final String clockInStatus;
  final String clockOutStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendanceNow({
    required this.id,
    required this.employee,
    required this.schedule,
    required this.date,
    required this.clockIn,
    required this.clockOut,
    required this.duration,
    required this.clockInStatus,
    required this.clockOutStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceNow.fromJson(Map<String, dynamic> json) => AttendanceNow(
    id: json["id"],
    employee: EmployeeAttendance.fromJson(json["employee"]),
    schedule: Schedule.fromJson(json["schedule"]),
    date: DateTime.parse(json["date"]),
    clockIn: json["clock_in"],
    clockOut: json["clock_out"],
    duration: json["duration"],
    clockInStatus: json["clock_in_status"],
    clockOutStatus: json["clock_out_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee": employee.toJson(),
    "schedule": schedule.toJson(),
    "date": date.toIso8601String(),
    "clock_in": clockIn,
    "clock_out": clockOut,
    "duration": duration,
    "clock_in_status": clockInStatus,
    "clock_out_status": clockOutStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class EmployeeAttendance {
  final String name;
  final String position;

  EmployeeAttendance({required this.name, required this.position});

  factory EmployeeAttendance.fromJson(Map<String, dynamic> json) =>
      EmployeeAttendance(name: json["name"], position: json["position"]);

  Map<String, dynamic> toJson() => {"name": name, "position": position};
}

class Schedule {
  final int id;
  final DateTime dateSchedule;
  final String status;
  final Shift shift;

  Schedule({
    required this.id,
    required this.dateSchedule,
    required this.status,
    required this.shift,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    dateSchedule: DateTime.parse(json["date_schedule"]),
    status: json["status"],
    shift: Shift.fromJson(json["shift"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date_schedule": dateSchedule.toIso8601String(),
    "status": status,
    "shift": shift.toJson(),
  };
}

class Shift {
  final int id;
  final String type;
  final String startTime;
  final String endTime;

  Shift({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    id: json["id"],
    type: json["type"],
    startTime: json["start_time"],
    endTime: json["end_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "start_time": startTime,
    "end_time": endTime,
  };
}
