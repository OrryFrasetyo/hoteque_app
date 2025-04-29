import 'package:hoteque_app/core/data/networking/response/schedule/schedule.dart';

class ScheduleEmployeeResponse {
  final bool error;
  final String message;
  final List<Schedule> schedules;

  ScheduleEmployeeResponse({
    required this.error,
    required this.message,
    required this.schedules,
  });

  factory ScheduleEmployeeResponse.fromJson(Map<String, dynamic> json) =>
      ScheduleEmployeeResponse(
        error: json["error"],
        message: json["message"],
        schedules: List<Schedule>.from(
          json["schedules"].map((x) => Schedule.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "schedules": List<dynamic>.from(schedules.map((x) => x.toJson())),
  };
}