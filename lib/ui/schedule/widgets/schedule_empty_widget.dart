// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class ScheduleEmptyWidget extends StatelessWidget {
//   final String message;

//   const ScheduleEmptyWidget({super.key, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Lottie.asset(
//             "assets/animations/empty.json",
//             width: 70,
//             height: 70,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Tarik ke bawah untuk menyegarkan',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }
// }
