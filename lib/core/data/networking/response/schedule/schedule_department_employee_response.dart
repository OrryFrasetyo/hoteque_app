class ScheduleDepartmentEmployeeResponse {
  final bool error;
  final String message;
  final Meta meta;
  final List<Schedule> schedules;

  ScheduleDepartmentEmployeeResponse({
    required this.error,
    required this.message,
    required this.meta,
    required this.schedules,
  });

  factory ScheduleDepartmentEmployeeResponse.fromJson(
    Map<String, dynamic> json,
  ) => ScheduleDepartmentEmployeeResponse(
    error: json["error"],
    message: json["message"],
    meta: Meta.fromJson(json["meta"]),
    schedules: List<Schedule>.from(
      json["schedules"].map((x) => Schedule.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "meta": meta.toJson(),
    "schedules": List<dynamic>.from(schedules.map((x) => x.toJson())),
  };
}

class Meta {
  final String date;
  final Department department;
  final int totalEmployees;

  Meta({
    required this.date,
    required this.department,
    required this.totalEmployees,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    date: json["date"],
    department: Department.fromJson(json["department"]),
    totalEmployees: json["total_employees"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "department": department.toJson(),
    "total_employees": totalEmployees,
  };
}

class Department {
  final int id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) =>
      Department(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Schedule {
  final DateTime createdAt;
  final Department createdBy;
  final DateTime dateSchedule;
  final Employee employee;
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
    createdBy: Department.fromJson(json["created_by"]),
    dateSchedule: DateTime.parse(json["date_schedule"]),
    employee: Employee.fromJson(json["employee"]),
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

class Employee {
  final int id;
  final String name;
  final String position;

  Employee({required this.id, required this.name, required this.position});

  factory Employee.fromJson(Map<String, dynamic> json) =>
      Employee(id: json["id"], name: json["name"], position: json["position"]);

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
