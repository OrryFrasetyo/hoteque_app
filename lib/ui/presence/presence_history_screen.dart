import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:hoteque_app/ui/presence/widget/attendance_month_widget.dart';
import 'package:provider/provider.dart';

import '../../core/data/networking/states/attendance/attendance_month_result_state.dart';
import '../../core/provider/attendance/attendance_month_provider.dart';

class PresenceHistoryScreen extends StatefulWidget {
  final VoidCallback onBack;
  const PresenceHistoryScreen({super.key, required this.onBack});

  @override
  State<PresenceHistoryScreen> createState() => _PresenceHistoryScreenState();
}

class _PresenceHistoryScreenState extends State<PresenceHistoryScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  void _initData() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final authProvider = context.read<AuthProvider>();
    final attendanceProvider = context.read<AttendanceMonthProvider>();

    if (authProvider.employee != null) {
      // Fetch monthly attendance data when screen is loaded
      await attendanceProvider.getAttendanceMonth(
        employee: authProvider.employee!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.brown),
                    onPressed: widget.onBack,
                  ),
                  Expanded(
                    child: Text(
                      'Riwayat Absensi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48), // Balance space dari back button
                ],
              ),
            ),

            SizedBox(height: 8),

            Consumer2<AttendanceMonthProvider, AuthProvider>(
              builder: (context, attendanceProvider, authProvider, _) {
                // If there's an error in the attendance state, we provide retry functionality
                if (attendanceProvider.state is AttendanceMonthErrorState) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          (attendanceProvider.state
                                  as AttendanceMonthErrorState)
                              .message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (authProvider.employee != null) {
                              attendanceProvider.getAttendanceMonth(
                                employee: authProvider.employee!,
                              );
                            }
                          },
                          child: Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }
                return AttendanceMonthWidget();
              },
            ),
          ],
        ),
      ),
    );
  }
}
