import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/schedule_employee.dart';
import 'package:intl/intl.dart';

class ScheduleItemWidget extends StatelessWidget {
  final ScheduleEmployee schedule;

  const ScheduleItemWidget({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final dayFormat = DateFormat.EEEE('id_ID');
    final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              '${dayFormat.format(schedule.dateSchedule)}, ${dateFormat.format(schedule.dateSchedule)}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.work_history,
                size: 40,
                color: Color(0xFF8B5E3C),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shift ${schedule.type}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      schedule.time,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
