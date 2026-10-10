import 'package:geolocator/geolocator.dart';

class LocationService {
  const LocationService();

  Future<bool> hasPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position> getCurrentLocation() async {
    await _ensureServiceEnabled();
    await _ensurePermissionGranted();

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  Future<void> _ensureServiceEnabled() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw AppLocationServiceDisabledException();
    }
  }

  Future<void> _ensurePermissionGranted() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      throw AppLocationPermissionDeniedForeverException();
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        throw AppLocationPermissionDeniedForeverException();
      }
      if (permission == LocationPermission.denied) {
        throw AppLocationPermissionDeniedException();
      }
    }
  }
}

class AppLocationServiceDisabledException implements Exception {}

class AppLocationPermissionDeniedException implements Exception {}

class AppLocationPermissionDeniedForeverException implements Exception {}
