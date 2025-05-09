import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/attendance/attendance_month_provider.dart';
import 'package:hoteque_app/core/provider/attendance/attendance_now_provider.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:hoteque_app/core/provider/profile/profile_provider.dart';
import 'package:hoteque_app/core/provider/schedule/schedule_employee_provider.dart';
import 'package:hoteque_app/core/provider/schedule/schedule_now_provider.dart';
import 'package:hoteque_app/ui/profile/edit_profile_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onLogout;
  const ProfileScreen({
    super.key,
    required this.onBack,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen()),
    );

    if (!mounted) return;

    // Jika hasil true, maka refresh data profil dari API
    if (result == true) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );

      await profileProvider.getProfile(employee: authProvider.employee!);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Keluar Akun'),
          content: Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );

                Provider.of<ProfileProvider>(
                  context,
                  listen: false,
                ).resetState();

                final scheduleNowProvider = Provider.of<ScheduleNowProvider>(
                  context,
                  listen: false,
                );
                scheduleNowProvider.resetState();

                // Reset schedule provider state
                Provider.of<ScheduleEmployeeProvider>(
                  context,
                  listen: false,
                ).resetState();

                Provider.of<AttendanceNowProvider>(
                  context,
                  listen: false,
                ).resetState();

                Provider.of<AttendanceMonthProvider>(
                  context,
                  listen: false,
                ).resetState();

                await authProvider.logout();

                if (!context.mounted) return;
                widget.onLogout();

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Keluar Akun Berhasil")));
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // HEADER + CONTENT
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 50, bottom: 70),
                    decoration: const BoxDecoration(
                      color: Color(0xFFA87640),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        // BACK & TITLE
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: widget.onBack,
                            ),
                            Expanded(
                              child: const Text(
                                'Profil',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 48), // balance back button
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Menampilkan status loading jika sedang loading
                        if (profileProvider.isLoading)
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),

                        _buildProfileAvatar(profileProvider),
                        SizedBox(height: 12),
                        Text(
                          profileProvider.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.email,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              profileProvider.email,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, color: Colors.white, size: 14),
                            SizedBox(width: 6),
                            Text(
                              profileProvider.phone,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // Menampilkan error message jika ada error
                        if (profileProvider.isError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Error: ${profileProvider.errorMessage}',
                              style: TextStyle(
                                color: Colors.red[100],
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // FLOATING BUTTON
                  Positioned(
                    bottom: -24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _navigateToEditProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8B5E3C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 48),

              // SETTING LAINNYA (placeholder)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _settingItem(
                      icon: Icons.nightlight_round,
                      title: 'Mode Gelap',
                      trailing: Switch(value: true, onChanged: (_) {}),
                    ),
                    SizedBox(height: 12),
                    _settingItem(
                      icon: Icons.logout,
                      title: 'Keluar',
                      trailing: Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget untuk menampilkan avatar profil dengan handling null
  Widget _buildProfileAvatar(ProfileProvider provider) {
    if (provider.hasPhoto && provider.photo != null) {
      final imageUrl = provider.photoUrl;
      print("Loading image from URL: $imageUrl");
      return CircleAvatar(
        radius: 50,
        backgroundColor: Color(0xFFD2B48C),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
            placeholder:
                (context, url) =>
                    CircularProgressIndicator(color: Colors.white),
            errorWidget:
                (context, url, error) =>
                    Icon(Icons.person, size: 60, color: Colors.white),
          ),
        ),
      );
    } else {
      // Tampilkan icon person jika foto tidak ada
      return CircleAvatar(
        radius: 50,
        backgroundColor: Color(0xFFD2B48C),
        child: Icon(Icons.person, size: 60, color: Colors.white),
      );
    }
  }

  Widget _settingItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE9DCCB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.brown),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
