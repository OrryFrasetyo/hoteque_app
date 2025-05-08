import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:hoteque_app/core/provider/profile/profile_provider.dart';
import 'package:hoteque_app/core/provider/schedule/schedule_now_provider.dart';
import 'package:hoteque_app/core/routes/my_route_delegate.dart';
import 'package:hoteque_app/ui/home/widget/attendance_card_widget.dart';
import 'package:hoteque_app/ui/home/widget/today_schedule_widget.dart';
import 'package:hoteque_app/ui/presence/presence_history_screen.dart';
import 'package:hoteque_app/ui/widget/attendance_history_item_widget.dart';
import 'package:hoteque_app/ui/home/widget/employee_header_widget.dart';
import 'package:hoteque_app/ui/home/widget/monthly_attendance_recap_widget.dart';
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

    if (authProvider.employee == null) {
      await authProvider.getEmployee();
    }

    if (authProvider.employee != null && authProvider.employee!.token != null) {
      if (mounted) {
        final profileProvider = context.read<ProfileProvider>();
        await profileProvider.getProfile(employee: authProvider.employee!);

        if (!mounted) return;
        final scheduleNowProvider = context.read<ScheduleNowProvider>();
        await scheduleNowProvider.getTodaySchedule(
          employee: authProvider.employee!,
        );
      }
    }
  }

  Future<void> _refreshHome() async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final scheduleNowProvider = context.read<ScheduleNowProvider>();

    await authProvider.getEmployee();

    if (authProvider.employee != null && authProvider.employee!.token != null) {
      await profileProvider.getProfile(employee: authProvider.employee!);
      await scheduleNowProvider.getTodaySchedule(
        employee: authProvider.employee!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, ProfileProvider>(
        builder: (context, authProvider, profileProvider, child) {
          if (authProvider.isLoadingLogin) {
            return Center(child: CircularProgressIndicator());
          }

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
                  TodayScheduleWidget(),
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
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return FloatingActionButton(
            backgroundColor: Color(0xFF90612D),
            onPressed: () {
              if (authProvider.employee != null) {
                // Get the RouterDelegate from the context
                final delegate =
                    Router.of(context).routerDelegate as MyRouteDelegate;
                // Navigate to the schedule screen
                delegate.navigateToScheduleEmployee(authProvider.employee!);
              } else {
                // Tampilkan pesan error jika employee belum tersedia
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Data karyawan tidak tersedia'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Icon(Icons.calendar_month, color: Colors.white),
          );
        },
      ),
    );
  }
}
