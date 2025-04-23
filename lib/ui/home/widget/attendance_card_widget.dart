import 'package:flutter/material.dart';
import 'package:hoteque_app/ui/presence/presence_history_now_screen.dart';

class AttendanceCardWidget extends StatelessWidget {
  const AttendanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                "Rabu, 3 Februari 2025",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Text(
                "08:30",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TimeItem(
                title: 'Hadir',
                icon: Icons.access_time_filled,
                time: '--:--',
              ),
              _TimeItem(
                title: 'Pulang',
                icon: Icons.access_time_filled,
                time: '--:--',
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                try {
                  debugPrint("Rekam Hadir Ditekan");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PresenceHistoryNowScreen(),
                    ),
                  );
                } catch (e) {
                  debugPrint("Error saat navigasi: $e");
                  // Alternatif navigasi jika cara pertama gagal
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              PresenceHistoryNowScreen(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF86572D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                "Rekam Hadir",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              time,
              style: TextStyle(
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
