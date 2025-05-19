import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/networking/states/attendance/attendance_now_result_state.dart';
import 'package:hoteque_app/core/provider/attendance/attendance_now_provider.dart';
import 'package:hoteque_app/core/routes/my_route_delegate.dart';
import 'package:provider/provider.dart';

class ButtonPresenceWidget extends StatelessWidget {
  const ButtonPresenceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceNowProvider>(
      builder: (context, provider, _) {
        // Tentukan teks tombol
        String buttonText =
            provider.state is AttendanceNowErrorState
                ? "Rekam Hadir"
                : provider.buttonText;

        bool isEnabled =
            provider.state is AttendanceNowErrorState
                ? true
                : provider.isButtonEnabled;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  isEnabled
                      ? () {
                        debugPrint("$buttonText Ditekan");
                        final routerDelegate =
                            Router.of(context).routerDelegate;
                        if (routerDelegate is MyRouteDelegate) {
                          routerDelegate.navigateToAttendanceMaps();
                        }
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF86572D),
                disabledBackgroundColor: const Color(0xFF86572D).withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
