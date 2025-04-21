import 'package:flutter/material.dart';

class TodayScheduleCardWidget extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final Color backgroundColor;

  const TodayScheduleCardWidget({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    this.backgroundColor = const Color(0xFFEFEFEF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Center(
            child: Column(
              children: [
                Icon(icon, size: 32, color: Color(0xFF90612D)),
                SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
