import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/attendance/location_provider.dart';
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

      // Simulate an API request
      await Future.delayed(const Duration(seconds: 2));

      // This would be replaced with a real API call
      // Example:
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/attendance'),
      //   body: jsonEncode({
      //     'userId': userId,
      //     'latitude': locationProvider.currentLocation.latitude,
      //     'longitude': locationProvider.currentLocation.longitude,
      //     'address': locationProvider.currentAddress,
      //     'timestamp': DateTime.now().toIso8601String(),
      //   }),
      //   headers: {'Content-Type': 'application/json'},
      // );

      // Log the attendance data (this would be saved to your backend)
      debugPrint('Recording attendance for user $userId');
      debugPrint(
        'Location: ${locationProvider.currentLocation.latitude}, ${locationProvider.currentLocation.longitude}',
      );
      debugPrint('Address: ${locationProvider.currentAddress}');
      debugPrint('Time: ${DateTime.now()}');

      return true; // Success
    } catch (e) {
      debugPrint('Error recording attendance: $e');
      return false; // Failure
    }
  }
}