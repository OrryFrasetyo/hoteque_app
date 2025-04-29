import 'package:hoteque_app/core/data/networking/response/schedule/schedule.dart';

class ScheduleEmployee {
  final String type;
  final String time;
  final DateTime dateSchedule;

  ScheduleEmployee({
    required this.type,
    required this.time,
    required this.dateSchedule,
  });

  factory ScheduleEmployee.fromSchedule(Schedule schedule) {
    return ScheduleEmployee(
      type: schedule.shift.type,
      time: "${schedule.shift.startTime} - ${schedule.shift.endTime}",
      dateSchedule: schedule.dateSchedule,
    );
  }
}
