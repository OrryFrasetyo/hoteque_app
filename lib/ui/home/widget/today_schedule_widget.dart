import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/networking/states/schedule/schedule_now_employee_result_state.dart';
import 'package:hoteque_app/core/provider/schedule/schedule_now_provider.dart';
import 'package:hoteque_app/ui/home/widget/today_schedule_card_widget.dart';
import 'package:provider/provider.dart';

class TodayScheduleWidget extends StatelessWidget {
  const TodayScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleNowProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        if (state is ScheduleNowEmployeeLoadingState) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF90612D),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Memuat jadwal...", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          );
        } else if (state is ScheduleNowEmployeeErrorState) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.event_busy, size: 32, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    "Tidak ada jadwal hari ini",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ScheduleNowEmployeeLoadedState) {
          if (state.schedules.isEmpty || provider.todaySchedule == null) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_busy, size: 32, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      "Tidak ada jadwal hari ini",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }

          // Menggunakan widget yang sudah ada dengan data dari provider
          return TodayScheduleCardWidget(
            type: provider.shiftType,
            time: provider.scheduleTime,
            icon: Icons.work_history,
          );
        } else {
          // Initial state
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.schedule, size: 32, color: Colors.grey[400]),
                  SizedBox(height: 8),
                  Text("Jadwal belum dimuat", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
