import 'dart:async';

import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw AppLocationServiceDisabledException();
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw AppLocationServiceDisabledException();
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw AppLocationPermissionDeniedException();
  }

  return Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
      timeLimit: Duration(seconds: 10),
    ),
  );
}

class AppLocationServiceDisabledException implements Exception {}

class AppLocationPermissionDeniedException implements Exception {}

class AppLocationPermissionDeniedForeverException implements Exception {}
