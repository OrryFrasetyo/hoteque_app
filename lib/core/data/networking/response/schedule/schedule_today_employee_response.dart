import 'package:hoteque_app/core/data/networking/response/schedule/schedule.dart';

class ScheduleTodayEmployeeResponse {
    final bool error;
    final String message;
    final Schedule schedule;

    ScheduleTodayEmployeeResponse({
        required this.error,
        required this.message,
        required this.schedule,
    });

    factory ScheduleTodayEmployeeResponse.fromJson(Map<String, dynamic> json) => ScheduleTodayEmployeeResponse(
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