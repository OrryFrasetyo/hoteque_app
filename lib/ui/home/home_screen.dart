import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/auth_provider.dart';
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
  void dispose() {
    super.dispose();
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

                  SizedBox(height: 16),

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
            onRefresh: () async {},
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  primary: true,
                  forceElevated: false,
                  title: Row(
                    children: [
                      Image.asset('assets/icon/logo-hotelqu.png', height: 30),
                      SizedBox(width: 8),
                      Text(
                        'Hotelqu',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () => _logOut(authProvider),
                      ),
                    ),
                  ],
                  elevation: 0,
                ),
              ],
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
