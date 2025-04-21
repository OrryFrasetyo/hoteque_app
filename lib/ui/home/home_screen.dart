import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/auth_provider.dart';
import 'package:hoteque_app/ui/home/widget/attendance_card_widget.dart';
import 'package:hoteque_app/ui/home/widget/employee_header_widget.dart';
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
                  Stack(
                    children: [
                      EmployeeHeaderWidget(),

                      // Card absensi
                      Positioned(
                        // Atur sesuai tinggi header
                        top: 110,
                        left: 8,
                        right: 8,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: AttendanceCardWidget(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
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
