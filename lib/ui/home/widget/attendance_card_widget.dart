import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/networking/states/attendance/clock_in_attendance_result_state.dart';
import '../../../core/provider/attendance/clock_in_attendance_provider.dart';
import '../../../core/data/networking/states/attendance/attendance_now_result_state.dart';
import '../../../core/provider/attendance/attendance_now_provider.dart';
import '../../../core/provider/auth/auth_provider.dart';
import '../../../core/provider/attendance/time_provider.dart';
import '../../presence/presence_history_now_screen.dart';
import 'package:provider/provider.dart';

class AttendanceCardWidget extends StatefulWidget {
  const AttendanceCardWidget({super.key});

  @override
  State<AttendanceCardWidget> createState() => _AttendanceCardWidgetState();
}

class _AttendanceCardWidgetState extends State<AttendanceCardWidget> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initAttendanceData();
  }

  void _initAttendanceData() {
    if (_isInitialized) return;
    _isInitialized = true;

    final authProvider = context.read<AuthProvider>();
    final attendanceNowProvider = context.read<AttendanceNowProvider>();

    if (authProvider.employee != null && authProvider.employee!.token != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        attendanceNowProvider.getAttendanceNow(
          employee: authProvider.employee!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      TimeProvider,
      AttendanceNowProvider,
      ClockInAttendanceProvider
    >(
      builder: (
        context,
        timeProvider,
        attendanceNowProvider,
        clockInProvider,
        _,
      ) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFAA8E4E),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeProvider.formattedDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  _DigitalClock(timeProvider: timeProvider),
                ],
              ),
              const SizedBox(height: 16.0),
              _buildAttendanceStatus(attendanceNowProvider),
              const SizedBox(height: 16),
              _buildAttendanceButton(
                attendanceNowProvider,
                clockInProvider,
                context,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceStatus(AttendanceNowProvider provider) {
    // Selalu tampilkan widget normal terlepas dari state (error/loading)
    // Jika state loading, tetap tampilkan widget normal dengan indikator loading kecil di pojok
    Widget statusWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _TimeItem(
          title: 'Hadir',
          icon: Icons.access_time_filled,
          time:
              provider.state is AttendanceNowErrorState
                  ? "--:--"
                  : provider.clockInTime,
        ),
        _TimeItem(
          title: 'Pulang',
          icon: Icons.access_time_filled,
          time:
              provider.state is AttendanceNowErrorState
                  ? "--:--"
                  : provider.clockOutTime,
        ),
      ],
    );

    // Tambahkan indikator loading jika sedang loading
    if (provider.state is AttendanceNowLoadingState) {
      return Stack(
        children: [
          statusWidget,
          const Positioned(
            right: 0,
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      );
    }

    return statusWidget;
  }

  Widget _buildAttendanceButton(
    AttendanceNowProvider attendanceProvider,
    ClockInAttendanceProvider clockInProvider,
    BuildContext context,
  ) {
    // Tentukan teks tombol
    String buttonText = "Rekam Hadir";
    // Jika state error, tetapkan teks tombol ke "Rekam Hadir"
    if (attendanceProvider.state is AttendanceNowErrorState) {
      buttonText = "Rekam Hadir";
    } else {
      buttonText = attendanceProvider.buttonText;
    }

    if (clockInProvider.state is ClockInAttendanceLoadingState) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF86572D),
            disabledBackgroundColor: Color(0xFF86572D).withAlpha(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
    // Button selalu diaktifkan jika dalam keadaan error
    bool isEnabled =
        attendanceProvider.state is AttendanceNowErrorState
            ? true
            : attendanceProvider.isButtonEnabled;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            isEnabled
                ? () {
                  _handleAttendanceButtonPress(context);
                }
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF86572D),
          disabledBackgroundColor: Color(0xFF86572D).withAlpha(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleAttendanceButtonPress(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final clockInProvider = context.read<ClockInAttendanceProvider>();
    final attendanceNowProvider = context.read<AttendanceNowProvider>();

    if (authProvider.employee == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data karyawan tidak tersedia'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Cek apakah ini rekam hadir atau rekam pulang
    if (attendanceNowProvider.buttonText == "Rekam Hadir") {
      // Proses rekam hadir
      clockInProvider.clockInAttendance(
        employee: authProvider.employee!,
        onSuccess: () {
          if (!context.mounted) return;
          // Refresh attendance data
          attendanceNowProvider.getAttendanceNow(
            employee: authProvider.employee!,
          );

          // Tampilkan success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil merekam kehadiran'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigasi ke riwayat presensi
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PresenceHistoryNowScreen(),
            ),
          );
        },
        onError: (errorMessage) {
          if (!context.mounted) return;
          // Tampilkan error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal merekam kehadiran: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    } else {
      // Ini adalah kasus rekam pulang, langsung arahkan ke halaman riwayat
      try {
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PresenceHistoryNowScreen(),
          ),
        );
      } catch (e) {
        debugPrint("Error saat navigasi: $e");
        if (!context.mounted) return;
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const PresenceHistoryNowScreen(),
          ),
        );
      }
    }
  }
}

// Widget khusus untuk jam digital yang efisien
class _DigitalClock extends StatelessWidget {
  final TimeProvider timeProvider;

  const _DigitalClock({required this.timeProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        timeProvider.formattedTime,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _TimeItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String time;

  const _TimeItem({
    required this.title,
    required this.icon,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 48, color: Colors.white),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
