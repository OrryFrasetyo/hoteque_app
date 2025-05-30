import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/networking/states/attendance/attendance_three_days_ago_result_state.dart';
import '../../../core/provider/attendance/attendance_three_days_provider.dart';
import 'attendance_history_item_widget.dart';

class AttendanceHistoryWidget extends StatelessWidget {
  const AttendanceHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceThreeDaysProvider>(
      builder: (context, provider, _) {
        // Using pattern matching for state handling
        return switch (provider.state) {
          AttendanceThreeDaysAgoLoadingState() => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(),
            ),
          ),

          AttendanceThreeDaysAgoErrorState state => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Retry logic will be implemented in parent
                  },
                  child: Text('Coba Lagi'),
                ),
              ],
            ),
          ),

          AttendanceThreeDaysAgoLoadedState state
              when state.attendances.isEmpty =>
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.event_busy, color: Color(0xFF8B5A2B), size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Tidak ada data absensi',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

          AttendanceThreeDaysAgoLoadedState state => Column(
            children:
                state.attendances.map((attendance) {
                  return AttendanceHistoryItemWidget(
                    date: attendance.date,
                    checkInTime: attendance.clockIn,
                    checkOutTime: attendance.clockOut,
                    checkInStatus: attendance.clockInStatus,
                    checkOutStatus: attendance.clockOutStatus,
                  );
                }).toList(),
          ),

          // Initial state or fallback
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
