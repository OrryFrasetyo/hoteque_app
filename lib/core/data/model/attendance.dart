class Attendance {
  final String clockIn;
  final String clockInStatus;
  final String clockOut;
  final String clockOutStatus;
  final DateTime createdAt;
  final DateTime date;
  final int id;
  final DateTime updatedAt;

  Attendance({
    required this.clockIn,
    required this.clockInStatus,
    required this.clockOut,
    required this.clockOutStatus,
    required this.createdAt,
    required this.date,
    required this.id,
    required this.updatedAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    clockIn: json["clock_in"],
    clockInStatus: json["clock_in_status"],
    clockOut: json["clock_out"],
    clockOutStatus: json["clock_out_status"],
    createdAt: DateTime.parse(json["created_at"]),
    date: DateTime.parse(json["date"]),
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
    "id": id,
    "updated_at": updatedAt.toIso8601String(),
  };
}