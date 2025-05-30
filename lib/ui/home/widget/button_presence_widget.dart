import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/networking/states/attendance/attendance_now_result_state.dart';
import 'package:hoteque_app/core/data/networking/states/schedule/schedule_now_employee_result_state.dart';
import 'package:hoteque_app/core/provider/attendance/attendance_now_provider.dart';
import 'package:hoteque_app/core/provider/schedule/schedule_now_provider.dart';
import 'package:hoteque_app/core/routes/my_route_delegate.dart';
import 'package:provider/provider.dart';

class ButtonPresenceWidget extends StatelessWidget {
  const ButtonPresenceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AttendanceNowProvider, ScheduleNowProvider>(
      builder: (context, attendanceProvider, scheduleProvider, _) {
        // Periksa apakah ada jadwal hari ini
        bool hasScheduleToday =
            scheduleProvider.state is ScheduleNowEmployeeLoadedState &&
            scheduleProvider.todaySchedule != null;

        // Jika tidak ada jadwal, tampilkan pesan informasi saja
        if (!hasScheduleToday) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_busy, color: Colors.brown),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Tidak ada jadwal kerja hari ini",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Tentukan teks tombol
        String buttonText =
            attendanceProvider.state is AttendanceNowErrorState
                ? "Rekam Hadir"
                : attendanceProvider.buttonText;

        bool isEnabled =
            attendanceProvider.state is AttendanceNowErrorState
                ? true
                : attendanceProvider.isButtonEnabled;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  isEnabled
                      ? () {
                        debugPrint("$buttonText Ditekan");
                        final routerDelegate =
                            Router.of(context).routerDelegate;
                        if (routerDelegate is MyRouteDelegate) {
                          routerDelegate.navigateToAttendanceMaps();
                        }
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF86572D),
                disabledBackgroundColor: const Color(0xFF86572D).withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
