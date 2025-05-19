import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_pkg;

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Future<LatLng?> getCurrentLocation() async {
    final location_pkg.Location location = location_pkg.Location();
    late bool serviceEnabled;
    late location_pkg.PermissionStatus permissionGranted;
    late location_pkg.LocationData locationData;

    try {
      // Check if location service is enabled
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          debugPrint("Location services is not available");
          return null;
        }
      }
      
      // Check location permission
      permissionGranted = await location.hasPermission();
      if (permissionGranted == location_pkg.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != location_pkg.PermissionStatus.granted) {
          debugPrint("Location permission is denied");
          return null;
        }
      }
      
      // Get location data
      locationData = await location.getLocation();
      return LatLng(locationData.latitude!, locationData.longitude!);
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.name ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.subAdministrativeArea ?? ''}, ${place.administrativeArea ?? ''}';
      }
      return "Lokasi tidak diketahui";
    } catch (e) {
      debugPrint('Error getting address: $e');
      return "Tidak dapat mendapatkan alamat";
    }
  }
}