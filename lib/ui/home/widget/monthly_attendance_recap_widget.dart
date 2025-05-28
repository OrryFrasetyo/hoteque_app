import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/attendance/attendance_month_provider.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:hoteque_app/ui/home/widget/recap_item_widget.dart';
import 'package:hoteque_app/ui/presence/screen/attendance_by_status_screen.dart';
import 'package:provider/provider.dart';

class MonthlyAttendanceRecapWidget extends StatefulWidget {
  const MonthlyAttendanceRecapWidget({super.key});

  @override
  State<MonthlyAttendanceRecapWidget> createState() =>
      _MonthlyAttendanceRecapWidgetState();
}

class _MonthlyAttendanceRecapWidgetState
    extends State<MonthlyAttendanceRecapWidget> {
  // Jumlah kehadiran berdasarkan status
  int _onTimeCount = 0;
  int _lateCount = 0;
  int _earlyLeaveCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAttendanceData();
    });
  }

  Future<void> _loadAttendanceData() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.employee != null) {
      final attendanceProvider = context.read<AttendanceMonthProvider>();
      await attendanceProvider.getAttendanceMonth(
        employee: authProvider.employee!,
      );

      // Hitung jumlah berdasarkan status
      if (attendanceProvider.attendanceList.isNotEmpty) {
        int onTime = 0;
        int late = 0;
        int earlyLeave = 0;

        for (var attendance in attendanceProvider.attendanceList) {
          // Hitung berdasarkan clock_in_status
          if (attendance.clockInStatus == "Tepat Waktu") {
            onTime++;
          } else if (attendance.clockInStatus == "Terlambat") {
            late++;
          }

          // Hitung berdasarkan clock_out_status
          if (attendance.clockOutStatus == "Pulang Lebih Awal") {
            earlyLeave++;
          }
        }

        setState(() {
          _onTimeCount = onTime;
          _lateCount = late;
          _earlyLeaveCount = earlyLeave;
        });
      }
    }
  }

  void _navigateToAttendanceByStatus(
    String statusType,
    String statusValue,
    String title,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AttendanceByStatusScreen(
              statusType: statusType,
              statusValue: statusValue,
              title: title,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Rekap Kehadiran Bulan Ini",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap:
                    () => _navigateToAttendanceByStatus(
                      "clock_in",
                      "Tepat Waktu",
                      "Kehadiran Tepat Waktu",
                    ),
                child: RecapItemWidget(
                  iconWidget: Image.asset(
                    "assets/icon/present.png",
                    width: 20,
                    height: 20,
                  ),
                  label: 'Hadir',
                  count: _onTimeCount,
                  backgroundColor: Colors.green,
                ),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap:
                    () => _navigateToAttendanceByStatus(
                      "clock_in",
                      "Terlambat",
                      "Kehadiran Terlambat",
                    ),
                child: RecapItemWidget(
                  iconWidget: Image.asset(
                    "assets/icon/late.png",
                    width: 20,
                    height: 20,
                  ),
                  label: 'Terlambat',
                  count: _lateCount,
                  backgroundColor: Colors.orange,
                ),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap:
                    () => _navigateToAttendanceByStatus(
                      "clock_out",
                      "Pulang Lebih Awal",
                      "Pulang Lebih Awal",
                    ),
                child: RecapItemWidget(
                  iconWidget: Image.asset(
                    "assets/icon/go_home.png",
                    width: 20,
                    height: 20,
                  ),
                  label: 'Pulang Awal',
                  count: _earlyLeaveCount,
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
