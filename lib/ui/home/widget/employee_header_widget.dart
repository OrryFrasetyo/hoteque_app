import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/profile_provider.dart';
import 'package:hoteque_app/ui/profile/profile_screen.dart';
import 'package:hoteque_app/core/data/networking/states/get_profile_result_state.dart';
import 'package:provider/provider.dart';

class EmployeeHeaderWidget extends StatelessWidget {
  const EmployeeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        return Container(
          width: double.infinity,
          height: 180,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA87640), Color(0xFF594023)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, ${profileProvider.name}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${profileProvider.position} - Hotelqu',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfileScreen()),
                      );
                    },
                    child: _buildProfileAvatar(profileProvider),
                  ),
                ],
              ),
              SizedBox(height: 8.0),

              // Pattern matching untuk state
              switch (profileProvider.state) {
                ProfileLoadingState() => LinearProgressIndicator(
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                ),
                ProfileErrorState() => Text(
                  'Gagal memuat data: ${profileProvider.errorMessage}',
                  style: TextStyle(color: Colors.red[100], fontSize: 12),
                ),
                _ => SizedBox.shrink(),
              },
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileAvatar(ProfileProvider provider) {
    if (provider.hasPhoto) {
      return CircleAvatar(
        radius: 32,
        backgroundImage: NetworkImage(provider.photo),
        onBackgroundImageError: (exception, stackTrace) {
          // Handle error loading image
        },
        child:
            provider.isLoading
                ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                : null,
      );
    } else {
      // Tampilkan icon person jika foto tidak ada
      return CircleAvatar(
        radius: 32,
        backgroundColor: Color(0xFFD2B48C),
        child: Icon(Icons.person, size: 40, color: Colors.white),
      );
    }
  }
}
