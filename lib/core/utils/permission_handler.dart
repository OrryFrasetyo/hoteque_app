import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class PermissionHandler {
  // Request location permission and return result
  static Future<bool> requestLocationPermission(BuildContext context) async {
    // Check if location permission is already granted
    final status = await ph.Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    // Request permission
    final result = await ph.Permission.location.request();

    if (result.isGranted) {
      return true;
    } else if (result.isPermanentlyDenied) {
      // Show a dialog to guide user to app settings
      if (context.mounted) {
        await _showPermissionPermanentlyDeniedDialog(context);
      }
      return false;
    } else {
      // Permission denied
      return false;
    }
  }

  // Show dialog when permission is permanently denied
  static Future<void> _showPermissionPermanentlyDeniedDialog(
    BuildContext context,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Izin Lokasi Diperlukan'),
          content: const Text(
            'Aplikasi memerlukan akses ke lokasi Anda untuk merekam kehadiran. '
            'Silakan aktifkan izin lokasi di pengaturan aplikasi.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ph.openAppSettings();
              },
              child: const Text('Buka Pengaturan'),
            ),
          ],
        );
      },
    );
  }
}
