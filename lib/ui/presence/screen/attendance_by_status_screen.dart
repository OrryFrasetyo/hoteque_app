import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/networking/states/attendance/attendance_by_status_result_state.dart';
import 'package:hoteque_app/core/provider/attendance/attendance_by_status_provider.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:hoteque_app/ui/presence/widget/attendance_history_item_widget.dart';
import 'package:provider/provider.dart';

class AttendanceByStatusScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String statusType; // "clock_in" atau "clock_out"
  final String
  statusValue; // "Tepat Waktu", "Terlambat", atau "Pulang Lebih Awal"
  final String title;

  const AttendanceByStatusScreen({
    super.key,
    required this.statusType,
    required this.statusValue,
    required this.title,
    required this.onBack,
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
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF8B5A2B),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBack,
        ),
      ),
      body: Consumer<AttendanceByStatusProvider>(
        builder: (context, provider, _) {
          try {
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
              AttendanceByStatusLoadedState state => state.attendances.isEmpty
                  ? _buildEmptyDataWidget() // Gunakan widget kosong yang sudah ada
                  : ListView.builder(
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
              _ => _buildEmptyDataWidget(),
            };
          } catch (e) {
            // Tangkap error dan tampilkan pesan yang lebih user-friendly
            debugPrint('Error di AttendanceByStatusScreen: $e'); // Untuk debugging
            return _buildEmptyDataWidget();
          }
        },
      ),
    );
  }

  // Widget untuk menampilkan pesan ketika data kosong atau terjadi error
  Widget _buildEmptyDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, color: Colors.grey, size: 48),
          const SizedBox(height: 16),
          Text(
            'Data kehadiran ${widget.statusValue} kosong',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada riwayat absensi dengan status ini',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: Icon(Icons.refresh),
            label: Text('Muat Ulang'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8B5A2B),
              foregroundColor: Colors.white,
            ),
          ),
        ],
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
