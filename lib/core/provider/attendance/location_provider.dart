import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../ui/presence/service/location_service.dart';
import 'dart:math' show asin, cos, pi, sin, sqrt;

class LocationProvider extends ChangeNotifier {
  final LatLng appskepOffice = const LatLng(
    -0.914133401830605,
    100.40204405577474,
  );
  // Radius kantor dalam meter (contoh: 70 meter)
  final double officeRadius = 70.0;

  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  LatLng _currentLocation;
  String _currentAddress = "Appskep Indonesia, Kec. Kuranji, Kota Padang";
  bool _isLoading = false;
  double _currentZoom = 18.0;

  LocationProvider()
    : _currentLocation = const LatLng(-0.914133401830605, 100.40204405577474);

  Set<Marker> get markers => _markers;
  Set<Circle> get circles => _circles;
  LatLng get currentLocation => _currentLocation;
  String get currentAddress => _currentAddress;
  bool get isLoading => _isLoading;

  void setMapController(GoogleMapController controller) async {
    _mapController = controller;
    // Add initial marker for office location
    _addMarker(appskepOffice, isOffice: true);
    // Add radius circle around office
    _addOfficeRadiusCircle();
    notifyListeners();

    // Get user's location automatically after map is created
    await Future.delayed(const Duration(milliseconds: 500));
    getCurrentLocation();
  }

  void _addMarker(LatLng position, {bool isOffice = false}) {
    // Clear user marker if adding user location
    if (!isOffice) {
      _markers.removeWhere((marker) => marker.markerId.value != "office");
    }

    _markers.add(
      Marker(
        markerId: MarkerId(isOffice ? "office" : "user"),
        position: position,
        icon:
            isOffice
                ? BitmapDescriptor.defaultMarker
                : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ),
        infoWindow: InfoWindow(
          title: isOffice ? "Appskep Indonesia" : "Lokasi Anda",
          snippet: isOffice ? "Kantor" : _currentAddress,
        ),
      ),
    );
    notifyListeners();
  }

  void _addOfficeRadiusCircle() {
    _circles.add(
      Circle(
        circleId: const CircleId("officeRadius"),
        center: appskepOffice,
        radius: officeRadius,
        fillColor: Colors.blue.withAlpha(20),
        strokeColor: Colors.blue,
        strokeWidth: 1,
      ),
    );
    notifyListeners();
  }

  void updateCameraPosition({LatLng? target, double? zoom}) async {
    if (_mapController == null) return;

    final LatLng newTarget = target ?? _currentLocation;
    final double newZoom = zoom ?? _currentZoom;
    _currentZoom = newZoom;

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newTarget, zoom: newZoom),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      final location = await _locationService.getCurrentLocation();

      if (location != null) {
        _currentLocation = location;

        // Update marker and camera position
        _addMarker(_currentLocation);
        updateCameraPosition(target: _currentLocation);

        // Get address from coordinates
        _currentAddress = await _locationService.getAddressFromLatLng(
          _currentLocation,
        );
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calculate distance between two coordinates using Haversine formula
  double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Earth radius in meters

    // Convert latitude and longitude from degrees to radians
    final double lat1Rad = point1.latitude * (pi / 180);
    final double lon1Rad = point1.longitude * (pi / 180);
    final double lat2Rad = point2.latitude * (pi / 180);
    final double lon2Rad = point2.longitude * (pi / 180);

    // Haversine formula
    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;
    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * asin(sqrt(a));

    return earthRadius * c; // Distance in meters
  }

  // Check if user is within office radius
  bool isWithinOfficeRadius() {
    double distance = calculateDistance(_currentLocation, appskepOffice);
    debugPrint("Distance to office: $distance meters");
    return distance <= officeRadius;
  }
}
