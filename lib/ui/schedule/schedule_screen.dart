import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/schedule.dart';
import 'package:hoteque_app/ui/schedule/schedule_item_widget.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ScheduleModel> schedules = [
      ScheduleModel(
        title: 'Shift Pagi',
        time: '08.00 WIB - 13.00 WIB',
        date: DateTime(2025, 2, 10),
      ),
      ScheduleModel(
        title: 'Shift Pagi',
        time: '08.00 WIB - 13.00 WIB',
        date: DateTime(2025, 2, 11),
      ),
      ScheduleModel(
        title: 'Shift Siang',
        time: '13.00 WIB - 21.00 WIB',
        date: DateTime(2025, 2, 12),
      ),
      ScheduleModel(
        title: 'Shift Siang',
        time: '13.00 WIB - 21.00 WIB',
        date: DateTime(2025, 2, 13),
      ),
      ScheduleModel(
        title: 'Shift Malam',
        time: '21.00 WIB - 08.00 WIB',
        date: DateTime(2025, 2, 14),
      ),
      ScheduleModel(
        title: 'Shift Malam',
        time: '21.00 WIB - 08.00 WIB',
        date: DateTime(2025, 2, 14),
      ),
      ScheduleModel(
        title: 'Shift Malam',
        time: '21.00 WIB - 08.00 WIB',
        date: DateTime(2025, 2, 14),
      ),
      ScheduleModel(
        title: 'Shift Malam',
        time: '21.00 WIB - 08.00 WIB',
        date: DateTime(2025, 2, 14),
      ),
    ];

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Jadwal Kerja Bulan Ini',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    return ScheduleItemWidget(schedule: schedules[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
