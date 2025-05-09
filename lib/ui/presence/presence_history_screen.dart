import 'package:flutter/material.dart';
import 'package:hoteque_app/ui/presence/widget/attendance_history_item_widget.dart';

class PresenceHistoryScreen extends StatelessWidget {
  const PresenceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dummyHistory = [
      {
        'date': DateTime(2025, 2, 1),
        'checkInTime': '07:59',
        'checkOutTime': '16:01',
        'checkInStatus': 'Tepat Waktu',
        'checkOutStatus': 'Tepat Waktu',
      },
      {
        'date': DateTime(2025, 2, 2),
        'checkInTime': '07:59',
        'checkOutTime': '16:01',
        'checkInStatus': 'Tepat Waktu',
        'checkOutStatus': 'Tepat Waktu',
      },
      {
        'date': DateTime(2025, 2, 3),
        'checkInTime': '07:59',
        'checkOutTime': '16:01',
        'checkInStatus': 'Tepat Waktu',
        'checkOutStatus': 'Tepat Waktu',
      },
      {
        'date': DateTime(2025, 2, 4),
        'checkInTime': '07:59',
        'checkOutTime': '16:01',
        'checkInStatus': 'Tepat Waktu',
        'checkOutStatus': 'Tepat Waktu',
      },
      {
        'date': DateTime(2025, 2, 5),
        'checkInTime': '07:59',
        'checkOutTime': '16:01',
        'checkInStatus': 'Tepat Waktu',
        'checkOutStatus': 'Tepat Waktu',
      },
      {
        'date': DateTime(2025, 2, 6),
        'checkInTime': '07:59',
        'checkOutTime': '16:01',
        'checkInStatus': 'Tepat Waktu',
        'checkOutStatus': 'Tepat Waktu',
      },
      {
        'date': DateTime(2025, 2, 7),
        'checkInTime': '07:59',
        'checkOutTime': '16:01',
        'checkInStatus': 'Tepat Waktu',
        'checkOutStatus': 'Tepat Waktu',
      },
      {
        'date': DateTime(2025, 2, 8),
        'checkInTime': '07:59',
        'checkOutTime': '16:01',
        'checkInStatus': 'Tepat Waktu',
        'checkOutStatus': 'Tepat Waktu',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.brown),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Riwayat Absensi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48), // Balance space dari back button
                ],
              ),
            ),

            SizedBox(height: 8),

            // ListView Builder
            Expanded(
              child: ListView.builder(
                itemCount: dummyHistory.length,
                itemBuilder: (context, index) {
                  final item = dummyHistory[index];
                  return AttendanceHistoryItemWidget(
                    date: item['date'],
                    checkInTime: item['checkInTime'],
                    checkOutTime: item['checkOutTime'],
                    checkInStatus: item['checkInStatus'],
                    checkOutStatus: item['checkOutStatus'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}