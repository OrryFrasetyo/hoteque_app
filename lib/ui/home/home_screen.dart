import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/auth_provider.dart';
import 'package:hoteque_app/core/provider/profile_provider.dart';
import 'package:hoteque_app/ui/home/widget/attendance_card_widget.dart';
import 'package:hoteque_app/ui/presence/presence_history_screen.dart';
import 'package:hoteque_app/ui/widget/attendance_history_item_widget.dart';
import 'package:hoteque_app/ui/home/widget/employee_header_widget.dart';
import 'package:hoteque_app/ui/home/widget/monthly_attendance_recap_widget.dart';
import 'package:hoteque_app/ui/home/widget/today_schedule_card_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const HomeScreen({super.key, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    await authProvider.getEmployee();

    // Pastikan employee sudah dimuat dan token tersedia sebelum memuat profil
    if (authProvider.employee != null && authProvider.employee!.token != null) {
      // Jika widget masih mounted, lanjutkan dengan memuat profil
      if (mounted) {
        final profileProvider = context.read<ProfileProvider>();
        await profileProvider.getProfile(employee: authProvider.employee!);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future <void> _refreshHome() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.getEmployee();

    // Refresh profile jika employee valid
    if (authProvider.employee != null && authProvider.employee!.token != null) {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.getProfile(employee: authProvider.employee!);
    }
  }

  void _logOut(AuthProvider authProvider) async {
    // Reset ProfileProvider saat logout
    context.read<ProfileProvider>().resetState();
    await authProvider.logout();
    widget.onLogout();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Keluar Akun Berhasil")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, ProfileProvider>(
        builder: (context, authProvider, profileProvider, child) {
          //loading state
          if (authProvider.isLoadingLogin) {
            return Center(child: CircularProgressIndicator());
          }

          // error employee state
          if (authProvider.errorMsg.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    "Error : ${authProvider.errorMsg}",
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),

                  ElevatedButton(
                    onPressed: widget.onLogout,
                    child: Text("Keluar"),
                  ),
                ],
              ),
            );
          }

          // employee not found
          if (authProvider.employee == null) {
            return Center(child: Text("Data Pengguna Tidak Tersedia"));
          }

          return RefreshIndicator(
            onRefresh: () => _refreshHome(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(child: EmployeeHeaderWidget()),
                        Positioned(
                          top: 160,
                          left: 16,
                          right: 16,
                          child: Builder(
                            builder:
                                (context) => Transform.translate(
                                  offset: Offset(0, -40),
                                  child: AttendanceCardWidget(),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                  MonthlyAttendanceRecapWidget(),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Jam Kerja Hari Ini",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  TodayScheduleCardWidget(
                    title: "Shift Reguler",
                    time: "08.00 WIB - 16.00 WIB",
                    icon: Icons.work_history,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Riwayat Absensi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PresenceHistoryScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Lihat Semua",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.brown,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  AttendanceHistoryItemWidget(
                    date: DateTime(2025, 2, 5),
                    checkInTime: "14.55",
                    checkOutTime: "22.05",
                    checkInStatus: "Tepat Waktu",
                    checkOutStatus: "Tepat Waktu",
                  ),
                  AttendanceHistoryItemWidget(
                    date: DateTime(2025, 2, 4),
                    checkInTime: "08:59",
                    checkOutTime: "16:15",
                    checkInStatus: "Terlambat",
                    checkOutStatus: "Tepat Waktu",
                  ),
                  AttendanceHistoryItemWidget(
                    date: DateTime(2025, 2, 3),
                    checkInTime: "07:59",
                    checkOutTime: "16:15",
                    checkInStatus: "Tepat Waktu",
                    checkOutStatus: "Tepat Waktu",
                  ),

                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _logOut(authProvider),
                    child: Text("Keluar"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
