import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PresenceHistoryNowScreen extends StatelessWidget {
  const PresenceHistoryNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime(2025, 2, 3); // dummy date
    final timeIn = "07:59";
    final timeOut = "16:01";
    final duration = Duration(hours: 8, minutes: 1, seconds: 0);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.brown),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Halo, Maxwell",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Commis Chef - Hotelqu_",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=65',
                    ),
                  ),
                ],
              ),
            ),

            // TANGGAL
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Rabu, ${DateFormat('dd-MM-yyyy').format(now)}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // WAKTU HADIR & PULANG
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _timeCard("Waktu Hadir", timeIn),
                  const SizedBox(width: 12),
                  _timeCard("Waktu Pulang", timeOut),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TOTAL DURASI
            const Text(
              "Total Durasi Kerja",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Icon(Icons.access_time, size: 36, color: Colors.brown),
            const SizedBox(height: 12),
            Text(
              "${duration.inHours.toString().padLeft(2, '0')} : "
              "${(duration.inMinutes % 60).toString().padLeft(2, '0')} : "
              "${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Jam     Menit     Detik",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const Spacer(),

            // TOMBOL KEMBALI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF86572D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Kembali Halaman Utama",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeCard(String title, String time) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.access_time, size: 24, color: Colors.brown),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            Text(
              time,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
