import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/data/networking/states/attendance/attendance_month_result_state.dart';
import '../../../core/provider/attendance/attendance_month_provider.dart';
import 'attendance_history_item_widget.dart';

class AttendanceMonthWidget extends StatelessWidget {
  const AttendanceMonthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceMonthProvider>(
      builder: (context, provider, _) {
        // Using pattern matching for state handling
        return switch (provider.state) {
          AttendanceMonthLoadingState() => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(),
            ),
          ),

          AttendanceMonthErrorState state => Padding(
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
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return ElevatedButton(
                      onPressed: () {
                        if (authProvider.employee != null) {
                          provider.getAttendanceMonth(
                            employee: authProvider.employee!,
                          );
                        }
                      },
                      child: Text('Coba Lagi'),
                    );
                  },
                ),
              ],
            ),
          ),

          AttendanceMonthLoadedState state when state.attendances.isEmpty =>
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
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
            ),

          AttendanceMonthLoadedState state => Expanded(
            child: ListView(
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
          ),

          // Initial state - show loading initially
          AttendanceMonthInitialState() => Center(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                // Initialize data automatically if we're in initial state
                if (authProvider.employee != null) {
                  // Use a post-frame callback to avoid triggering during build
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    provider.getAttendanceMonth(
                      employee: authProvider.employee!,
                    );
                  });
                }
                return CircularProgressIndicator();
              },
            ),
          ),

          // Initial state or fallback
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
