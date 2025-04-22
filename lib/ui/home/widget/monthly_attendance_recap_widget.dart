import 'package:flutter/material.dart';
import 'package:hoteque_app/ui/home/widget/recap_item_widget.dart';
import 'package:hoteque_app/ui/presence/presence_history_screen.dart';

class MonthlyAttendanceRecapWidget extends StatelessWidget {
  const MonthlyAttendanceRecapWidget({super.key});

  void _navigateToPresenceHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PresenceHistoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Rekap Kehadiran Bulan Ini",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _navigateToPresenceHistory(context),
                child: RecapItemWidget(
                  iconWidget: Image.asset(
                    "assets/icon/present.png",
                    width: 20,
                    height: 20,
                  ),
                  label: 'Hadir',
                  count: 5,
                  backgroundColor: Colors.green,
                ),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () => _navigateToPresenceHistory(context),
                child: RecapItemWidget(
                  iconWidget: Image.asset(
                    "assets/icon/no_present.png",
                    width: 20,
                    height: 20,
                  ),
                  label: 'Tidak Hadir',
                  count: 1,
                  backgroundColor: Colors.red,
                ),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () => _navigateToPresenceHistory(context),
                child: RecapItemWidget(
                  iconWidget: Image.asset(
                    "assets/icon/late.png",
                    width: 20,
                    height: 20,
                  ),
                  label: 'Terlambat',
                  count: 5,
                  backgroundColor: Colors.orange,
                ),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () => _navigateToPresenceHistory(context),
                child: RecapItemWidget(
                  iconWidget: Image.asset(
                    "assets/icon/go_home.png",
                    width: 20,
                    height: 20,
                  ),
                  label: 'Pulang Awal',
                  count: 5,
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
