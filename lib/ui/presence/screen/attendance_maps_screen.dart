import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoteque_app/core/provider/attendance/clock_in_out_attendance_provider.dart';
import 'package:hoteque_app/core/provider/attendance/location_provider.dart';
import 'package:hoteque_app/core/provider/attendance/attendance_now_provider.dart';
import 'package:hoteque_app/ui/presence/widget/draggable_location_sheet.dart';
import 'package:provider/provider.dart';

class AttendanceMapsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AttendanceMapsScreen({super.key, required this.onBack});

  @override
  State<AttendanceMapsScreen> createState() => _AttendanceMapsScreenState();
}

class _AttendanceMapsScreenState extends State<AttendanceMapsScreen> {
  @override
  void initState() {
    super.initState();
    // Reset the ClockInAttendanceProvider state when entering this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clockInProvider = Provider.of<ClockInOutAttendanceProvider>(
        context,
        listen: false,
      );
      clockInProvider.resetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationProvider, AttendanceNowProvider>(
      builder: (context, locationProvider, attendanceNowProvider, _) {
        // Tentukan judul berdasarkan status absensi
        final String title = attendanceNowProvider.buttonText;
        
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.5,
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  zoom: 18,
                  target: locationProvider.appskepOffice,
                ),
                onMapCreated: (controller) {
                  locationProvider.setMapController(controller);
                },
                markers: locationProvider.markers,
                circles: locationProvider.circles,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                compassEnabled: true,
              ),

              // Loading indicator while getting location
              if (locationProvider.isLoading)
                const Center(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Mendapatkan lokasi...'),
                        ],
                      ),
                    ),
                  ),
                ),

              // My location button
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  heroTag: "locationBtn",
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  elevation: 4,
                  mini: true,
                  child: const Icon(Icons.my_location),
                  onPressed: () => locationProvider.getCurrentLocation(),
                ),
              ),

              // Zoom controls
              Positioned(
                top: 80,
                right: 16,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: "zoomInBtn",
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 4,
                      mini: true,
                      child: const Icon(Icons.add),
                      onPressed:
                          () => locationProvider.updateCameraPosition(zoom: 19),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: "zoomOutBtn",
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 4,
                      mini: true,
                      child: const Icon(Icons.remove),
                      onPressed:
                          () => locationProvider.updateCameraPosition(zoom: 16),
                    ),
                  ],
                ),
              ),

              // Bottom draggable sheet
              const DraggableLocationSheet(),
            ],
          ),
        );
      },
    );
  }
}
