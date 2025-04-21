import 'package:flutter/material.dart';

class AttendanceCardWidget extends StatelessWidget {
  const AttendanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Rabu, 3 Februari 2025",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("08:30", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _TimeItem(
                  title: 'Hadir',
                  icon: Icons.access_time,
                  time: '--:--',
                ),
                _TimeItem(title: 'Pulang', icon: Icons.logout, time: '--:--'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF86572D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Rekam Hadir"),
              ),
            ),
          ],
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
    return Column(
      children: [
        Icon(icon, size: 36),
        const SizedBox(height: 4),
        Text(title),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
