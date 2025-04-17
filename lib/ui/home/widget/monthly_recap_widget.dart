import 'package:flutter/material.dart';

class MonthlyRecapWidget extends StatelessWidget {
  const MonthlyRecapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan lebar layar untuk perhitungan responsif
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rekap Kehadiran Bulan Ini",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Mengganti Row dengan Wrap
          Wrap(
            spacing: 8, // Jarak horizontal antar item
            runSpacing: 8, // Jarak vertikal antar baris
            alignment: WrapAlignment.spaceBetween,
            children: [
              _buildAttendanceStatCard(
                "Hadir",
                "5",
                Icons.person,
                Colors.blue,
                screenWidth,
              ),
              _buildAttendanceStatCard(
                "Tidak Hadir",
                "1",
                Icons.event_busy,
                Colors.red,
                screenWidth,
              ),
              _buildAttendanceStatCard(
                "Terlambat",
                "3",
                Icons.access_time_filled,
                Colors.amber,
                screenWidth,
              ),
              _buildAttendanceStatCard(
                "Plg Awal", // Mempersingkat teks
                "5",
                Icons.directions_run,
                Colors.green,
                screenWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
    double screenWidth,
  ) {
    // Menghitung ukuran card yang responsif
    // Dengan padding 16px di kedua sisi dan jarak 8px antar card
    // Untuk 4 card per baris, bagi dengan 4.2 agar ada sedikit ruang ekstra
    final cardWidth = (screenWidth - 32 - 24) / 4.2;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(radius: 16, backgroundColor: color.withAlpha(20)),
                Icon(icon, color: color, size: 20),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // Menangani teks panjang
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            CircleAvatar(
              radius: 10,
              backgroundColor: color.withAlpha(20),
              child: Text(
                count,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class MonthlyRecapWidget extends StatelessWidget {
//   const MonthlyRecapWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Rekap Kehadiran Bulan Ini",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildAttendanceStatCard("Hadir", "5", Icons.person, Colors.blue),
//               _buildAttendanceStatCard(
//                 "Tidak Hadir",
//                 "1",
//                 Icons.event_busy,
//                 Colors.red,
//               ),
//               _buildAttendanceStatCard(
//                 "Terlambat",
//                 "3",
//                 Icons.access_time_filled,
//                 Colors.amber,
//               ),
//               _buildAttendanceStatCard(
//                 "Pulang Lebih Awal",
//                 "5",
//                 Icons.directions_run,
//                 Colors.green,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAttendanceStatCard(
//     String title,
//     String count,
//     IconData icon,
//     Color color,
//   ) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Container(
//         width: 80,
//         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundColor: color.withAlpha(20),
//                 ),
//                 Icon(icon, color: color, size: 20),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//             ),
//             SizedBox(height: 4),
//             CircleAvatar(
//               radius: 10,
//               backgroundColor: color.withAlpha(20),
//               child: Text(
//                 count,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
