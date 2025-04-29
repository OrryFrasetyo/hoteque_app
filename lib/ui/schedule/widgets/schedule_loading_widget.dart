import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ScheduleLoadingWidget extends StatelessWidget {
  final String message;

  const ScheduleLoadingWidget({super.key, this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/animations/loading.json",
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
