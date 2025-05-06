class Schedule {
  final DateTime createdAt;
  final DateTime dateSchedule;
  final int id;
  final Shift shift;
  final DateTime updatedAt;

  Schedule({
    required this.createdAt,
    required this.dateSchedule,
    required this.id,
    required this.shift,
    required this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    createdAt: DateTime.parse(json["created_at"]),
    dateSchedule: DateTime.parse(json["date_schedule"]),
    id: json["id"],
    shift: Shift.fromJson(json["shift"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "date_schedule": dateSchedule.toIso8601String(),
    "id": id,
    "shift": shift.toJson(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Shift {
  final String endTime;
  final int id;
  final String startTime;
  final String type;

  Shift({
    required this.endTime,
    required this.id,
    required this.startTime,
    required this.type,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    endTime: json["end_time"],
    id: json["id"],
    startTime: json["start_time"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "end_time": endTime,
    "id": id,
    "start_time": startTime,
    "type": type,
  };
}
