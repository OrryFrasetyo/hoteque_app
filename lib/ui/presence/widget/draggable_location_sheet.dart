import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/networking/states/attendance/clock_in_out_attendance_result_state.dart';
import 'package:hoteque_app/core/provider/attendance/clock_in_out_attendance_provider.dart';
import 'package:hoteque_app/core/provider/attendance/location_provider.dart';
import 'package:hoteque_app/core/provider/attendance/attendance_now_provider.dart';
import 'package:hoteque_app/core/provider/auth/auth_provider.dart';
import 'package:hoteque_app/core/routes/my_route_delegate.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DraggableLocationSheet extends StatefulWidget {
  const DraggableLocationSheet({super.key});

  @override
  State<DraggableLocationSheet> createState() => _DraggableLocationSheetState();
}

class _DraggableLocationSheetState extends State<DraggableLocationSheet>
    with SingleTickerProviderStateMixin {
  // Initial and maximum heights for the sheet
  final double _minHeight = 150.0;
  final double _maxHeight = 300.0;
  bool _isSubmitting = false;

  // Animation controller for smoother dragging
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<double>(
      begin: _minHeight,
      end: _maxHeight,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.value = 0.0; // Start with minimum height

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clockInProvider = Provider.of<ClockInOutAttendanceProvider>(
        context,
        listen: false,
      );

      clockInProvider.resetState();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSheetHeight(double dragAmount) {
    final newValue =
        _controller.value - (dragAmount / (_maxHeight - _minHeight));
    _controller.value = newValue.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final clockInProvider = Provider.of<ClockInOutAttendanceProvider>(context);
    final attendanceNowProvider = Provider.of<AttendanceNowProvider>(context);

    setState(() {
      _isSubmitting = clockInProvider.state is ClockInOutAttendanceLoadingState;
    });

    // Tentukan teks tombol berdasarkan status absensi
    final String buttonText = attendanceNowProvider.buttonText;
    final bool isClockOut = buttonText == "Rekam Pulang";

    return Positioned(
      bottom: 0,
      child: AnimatedBuilder(
        animation: _heightAnimation,
        builder: (context, child) {
          return GestureDetector(
            onVerticalDragUpdate: (details) {
              _updateSheetHeight(details.delta.dy);
            },
            onVerticalDragEnd: (details) {
              // Snap to either min or max height based on velocity and current position
              if (details.velocity.pixelsPerSecond.dy > 0 &&
                  _controller.value < 0.7) {
                // Swipe down and not too high up - go to min height
                _controller.animateTo(0.0);
              } else if (details.velocity.pixelsPerSecond.dy < 0 &&
                  _controller.value > 0.3) {
                // Swipe up and already partially up - go to max height
                _controller.animateTo(1.0);
              } else if (_controller.value > 0.5) {
                // Above halfway - go to max height
                _controller.animateTo(1.0);
              } else {
                // Below halfway - go to min height
                _controller.animateTo(0.0);
              }
            },
            child: Container(
              height: _heightAnimation.value,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Determine if we're in compact mode
                          final bool isCompact = constraints.maxHeight < 200;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Lokasi Anda Saat Ini',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.brown,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        locationProvider.currentAddress,
                                        style: const TextStyle(fontSize: 14),
                                        maxLines: isCompact ? 1 : 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                // Status area showing whether user is within office radius
                                if (!isCompact)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          locationProvider
                                                  .isWithinOfficeRadius()
                                              ? Icons.check_circle
                                              : Icons.warning,
                                          color:
                                              locationProvider
                                                      .isWithinOfficeRadius()
                                                  ? Colors.green
                                                  : Colors.orange,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          locationProvider
                                                  .isWithinOfficeRadius()
                                              ? 'Anda berada dalam radius kantor'
                                              : 'Anda berada di luar radius kantor',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                locationProvider
                                                        .isWithinOfficeRadius()
                                                    ? Colors.green
                                                    : Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // Use Spacer only if not in compact mode
                                isCompact
                                    ? const SizedBox(height: 10)
                                    : const Spacer(),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                    bottom: isCompact ? 10 : 20,
                                  ),
                                  child: ElevatedButton(
                                    onPressed:
                                        _isSubmitting
                                            ? null
                                            : () => _handleRecordAttendance(
                                              context,
                                              isClockOut: isClockOut,
                                            ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF9F734A),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: isCompact ? 10 : 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child:
                                        _isSubmitting
                                            ? const SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : Text(
                                              buttonText,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRecordAttendance(
    BuildContext context, {
    bool isClockOut = false,
  }) async {
    // Get auth provider to access the employee data
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.employee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data karyawan tidak tersedia"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get location provider to check if user is within radius
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    final withinRadius = locationProvider.isWithinOfficeRadius();

    if (!withinRadius) {
      // Show error message if user is not within office radius
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Gagal mencatat kehadiran: Anda berada di luar radius kantor",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get current time in HH:mm format
    // final now = DateTime.now();
    // final formattedTime = DateFormat('HH:mm').format(now);

    // Get clock in provider
    final clockInProvider = Provider.of<ClockInOutAttendanceProvider>(
      context,
      listen: false,
    );

    // Tentukan apakah ini clock in atau clock out
    if (isClockOut) {
      // Panggil clock out
      await clockInProvider.clockOutAttendance(
        employee: authProvider.employee!,
        onSuccess: () {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Rekam pulang berhasil dicatat"),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back to home screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Use Router for navigation
            final routerDelegate = Router.of(context).routerDelegate;
            if (routerDelegate is MyRouteDelegate) {
              routerDelegate.navigateToHome();
            } else {
              // Fallback to Navigator if Router is not available
              Navigator.of(context).pop();
            }
          });
        },
        onError: (errorMsg) {
          // Show error message
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text("Gagal mencatat rekam pulang: $errorMsg"),
          //     backgroundColor: Colors.red,
          //   ),
          // );
          String displayMessage = _extractErrorMessage(errorMsg);

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Gagal mencatat rekam pulang: $displayMessage"),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        },
      );
    } else {
      // Panggil clock in
      await clockInProvider.clockInAttendance(
        employee: authProvider.employee!,
        onSuccess: () {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Kehadiran berhasil dicatat"),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back to home screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Use Router for navigation
            final routerDelegate = Router.of(context).routerDelegate;
            if (routerDelegate is MyRouteDelegate) {
              routerDelegate.navigateToHome();
            } else {
              // Fallback to Navigator if Router is not available
              Navigator.of(context).pop();
            }
          });
        },
        onError: (errorMsg) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Gagal mencatat kehadiran: $errorMsg"),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    }
  }

  String _extractErrorMessage(String errorMsg) {
    // Jika error message mengandung "Exception: ", hapus prefix tersebut
    if (errorMsg.startsWith('Exception: ')) {
      return errorMsg.substring(11); // Hapus "Exception: "
    }

    // Jika masih mengandung format lama, coba ekstrak pesan yang lebih bermakna
    if (errorMsg.contains('Status code:')) {
      // Jika pesan masih format lama, return pesan default yang lebih user-friendly
      return "Terjadi kesalahan. Silakan coba lagi.";
    }

    return errorMsg;
  }
}
