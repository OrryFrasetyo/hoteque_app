import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/auth_provider.dart';
import 'package:hoteque_app/ui/home/widget/attendance_card_widget.dart';
import 'package:hoteque_app/ui/home/widget/attendance_history_item_widget.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  void _initData() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.getEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
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
            onRefresh: () async {
              await authProvider.getEmployee();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 220, // Tinggi total dari header + card + spacing
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(child: EmployeeHeaderWidget()),
                        Positioned(
                          top: 160, // posisi card agar tidak menutupi header
                          left: 16,
                          right: 16,
                          child: Transform.translate(
                            offset: Offset(0, -40),
                            child: AttendanceCardWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                  MonthlyAttendanceRecapWidget(),
                  SizedBox(height: 16),
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
                            // Placeholder: Aksi lihat semua nanti ditambahkan
                          },
                          child: const Text(
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
                    child: const Text("Keluar"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _logOut(AuthProvider authProvider) async {
    await authProvider.logout();
    widget.onLogout();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Keluar Akun Berhasil")));
    }
  }
}
