import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceCardWidget extends StatelessWidget {
  const AttendanceCardWidget({super.key});

  // String _getFormattedDate() {
  //   final now = DateTime.now();
  //   final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  //   return formatter.format(now);
  // }

  // String _getFormattedTime() {
  //   final now = DateTime.now();
  //   final formatter = DateFormat('HH:mm');
  //   return formatter.format(now);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFA67C52),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rabu, 3 Februari 2025",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                "08:30",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildAttendanceStatus(
                  "Hadir",
                  Icons.access_time,
                  "--:--",
                ),
              ),
              Container(
                height: 70,
                width: 1,
                color: Colors.white30,
                margin: EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: _buildAttendanceStatus(
                  "Pulang",
                  Icons.access_time,
                  "--:--",
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              "Rekam Hadir",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStatus(String title, IconData icon, String time) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.brown),
        ),
        SizedBox(height: 8),
        Text(time, style: TextStyle(fontSize: 14, color: Colors.white)),
      ],
    );
  }
}
