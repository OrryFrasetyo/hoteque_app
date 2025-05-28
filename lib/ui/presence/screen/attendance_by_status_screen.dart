import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/networking/states/attendance/attendance_by_status_result_state.dart';
import 'package:hoteque_app/core/provider/attendance/attendance_by_status_provider.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:hoteque_app/ui/presence/widget/attendance_history_item_widget.dart';
import 'package:provider/provider.dart';

class AttendanceByStatusScreen extends StatefulWidget {
  final String statusType; // "clock_in" atau "clock_out"
  final String
  statusValue; // "Tepat Waktu", "Terlambat", atau "Pulang Lebih Awal"
  final String title;

  const AttendanceByStatusScreen({
    super.key,
    required this.statusType,
    required this.statusValue,
    required this.title,
  });

  @override
  State<AttendanceByStatusScreen> createState() =>
      _AttendanceByStatusScreenState();
}

class _AttendanceByStatusScreenState extends State<AttendanceByStatusScreen> {
  late final AttendanceByStatusProvider _statusProvider; // Simpan provider
  @override
  void initState() {
    super.initState();
    _statusProvider = context.read<AttendanceByStatusProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final statusProvider = context.read<AttendanceByStatusProvider>();

    if (authProvider.employee != null) {
      if (widget.statusType == "clock_in") {
        await statusProvider.getAttendanceByClockInStatus(
          employee: authProvider.employee!,
          status: widget.statusValue,
        );
      } else if (widget.statusType == "clock_out") {
        await statusProvider.getAttendanceByClockOutStatus(
          employee: authProvider.employee!,
          status: widget.statusValue,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AttendanceByStatusProvider>(
        builder: (context, provider, _) {
          return switch (provider.state) {
            AttendanceByStatusLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            AttendanceByStatusErrorState state => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
            AttendanceByStatusLoadedState state
                when state.attendances.isEmpty =>
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, color: Colors.grey, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada data absensi dengan status ${widget.statusValue}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            AttendanceByStatusLoadedState state => ListView.builder(
              itemCount: state.attendances.length,
              itemBuilder: (context, index) {
                final attendance = state.attendances[index];
                return AttendanceHistoryItemWidget(
                  date: attendance.date,
                  checkInTime: attendance.clockIn,
                  checkOutTime: attendance.clockOut,
                  checkInStatus: attendance.clockInStatus,
                  checkOutStatus: attendance.clockOutStatus,
                );
              },
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  @override
  void dispose() {
    // Reset state saat screen ditutup
    _statusProvider.resetState();
    super.dispose();
  }
}
