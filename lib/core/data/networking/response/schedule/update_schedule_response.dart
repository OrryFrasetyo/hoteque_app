class UpdateScheduleResponse {
  final bool error;
  final String message;
  final Schedule schedule;

  UpdateScheduleResponse({
    required this.error,
    required this.message,
    required this.schedule,
  });

  factory UpdateScheduleResponse.fromJson(Map<String, dynamic> json) =>
      UpdateScheduleResponse(
        error: json["error"],
        message: json["message"],
        schedule: Schedule.fromJson(json["schedule"]),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "schedule": schedule.toJson(),
  };
}

class Schedule {
  final DateTime createdAt;
  final CreatedBy createdBy;
  final DateTime dateSchedule;
  final EmployeeUpdate employee;
  final int id;
  final Shift shift;
  final String status;
  final DateTime updatedAt;

  Schedule({
    required this.createdAt,
    required this.createdBy,
    required this.dateSchedule,
    required this.employee,
    required this.id,
    required this.shift,
    required this.status,
    required this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: CreatedBy.fromJson(json["created_by"]),
    dateSchedule: DateTime.parse(json["date_schedule"]),
    employee: EmployeeUpdate.fromJson(json["employee"]),
    id: json["id"],
    shift: Shift.fromJson(json["shift"]),
    status: json["status"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy.toJson(),
    "date_schedule": dateSchedule.toIso8601String(),
    "employee": employee.toJson(),
    "id": id,
    "shift": shift.toJson(),
    "status": status,
    "updated_at": updatedAt.toIso8601String(),
  };
}

class CreatedBy {
  final int id;
  final String name;

  CreatedBy({required this.id, required this.name});

  factory CreatedBy.fromJson(Map<String, dynamic> json) =>
      CreatedBy(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class EmployeeUpdate {
  final int id;
  final String name;
  final String position;

  EmployeeUpdate({required this.id, required this.name, required this.position});

  factory EmployeeUpdate.fromJson(Map<String, dynamic> json) =>
      EmployeeUpdate(id: json["id"], name: json["name"], position: json["position"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "position": position,
  };
}

class Shift {
  final String clockIn;
  final String clockOut;
  final int id;
  final String name;

  Shift({
    required this.clockIn,
    required this.clockOut,
    required this.id,
    required this.name,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    clockIn: json["clock_in"],
    clockOut: json["clock_out"],
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "clock_in": clockIn,
    "clock_out": clockOut,
    "id": id,
    "name": name,
  };
}
