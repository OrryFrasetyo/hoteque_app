import 'package:flutter/material.dart';

class AttendanceHistoryItemWidget extends StatelessWidget {
  final DateTime date;
  final String checkInTime;
  final String checkOutTime;
  final String checkInStatus;
  final String checkOutStatus;

  const AttendanceHistoryItemWidget({
    super.key,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.checkInStatus,
    required this.checkOutStatus,
  });

  @override
  Widget build(BuildContext context) {
    final day = date.day;
    final weekday = _weekdayLabel(date.weekday);
    final month = _monthLabel(date.month);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$day",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "$weekday\n$month ${date.year}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(width: 20),

          // Divider
          Container(width: 3, height: 50, color: Colors.grey.shade300),

          SizedBox(width: 16),

          // Hadir & Pulang Column
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Check In
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hadir",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(checkInTime, style: const TextStyle(fontSize: 12)),
                    Text(
                      checkInStatus,
                      style: TextStyle(
                        fontSize: 12,
                        color: _statusColor(checkInStatus),
                      ),
                    ),
                  ],
                ),
                // Check Out
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Pulang",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(checkOutTime, style: TextStyle(fontSize: 12)),
                    Text(
                      checkOutStatus,
                      style: TextStyle(
                        fontSize: 12,
                        color: _statusColor(checkOutStatus),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayLabel(int weekday) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[weekday - 1];
  }

  String _monthLabel(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "tepat waktu":
        return Colors.green;
      case "terlambat":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
