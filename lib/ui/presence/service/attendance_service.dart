import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/attendance/clock_in_out_attendance_provider.dart';
import 'package:hoteque_app/core/provider/attendance/location_provider.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:hoteque_app/core/routes/my_route_delegate.dart';
import 'package:provider/provider.dart';

class AttendanceService {
  static final AttendanceService _instance = AttendanceService._internal();
  factory AttendanceService() => _instance;
  AttendanceService._internal();

  // Record attendance and check if user is within office radius
  Future<bool> recordAttendance({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      // Get current location data from provider
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );

      // Check if user is within office radius
      if (!locationProvider.isWithinOfficeRadius()) {
        debugPrint('User is outside office radius');
        return false; // User is not within the office radius
      }

      // Get the auth provider to access employee data
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.employee == null) {
        debugPrint('Employee data is not available');
        return false;
      }

      // Get clock in provider
      final clockInProvider = Provider.of<ClockInOutAttendanceProvider>(
        context,
        listen: false,
      );

      // Flag to track success of the operation
      bool success = false;

      // Call the clock in API
      await clockInProvider.clockInAttendance(
        employee: authProvider.employee!,
        onSuccess: () {
          success = true;

          // Navigate back to home screen (delay slightly to allow state update)
          Future.microtask(() {
            // Use Router for navigation
            if (!context.mounted) return;
            final routerDelegate = Router.of(context).routerDelegate;
            if (routerDelegate is MyRouteDelegate) {
              routerDelegate.navigateToHome();
            }
          });
        },
        onError: (errorMsg) {
          success = false;
          debugPrint('Error recording attendance: $errorMsg');
        },
      );

      return success;
    } catch (e) {
      debugPrint('Error recording attendance: $e');
      return false; // Failure
    }
  }
}
