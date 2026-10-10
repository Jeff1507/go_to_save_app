import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_to_save_app/core/geolocation/location_service.dart';

class LocationNotifier extends AsyncNotifier<Position?> {
  final LocationService _service = const LocationService();

  @override
  FutureOr<Position?> build() => _initialFetch();

  Future<Position?> _initialFetch() async {
    final alreadyGranted = await _service.hasPermission();
    if (!alreadyGranted) return null;

    return _service.getCurrentLocation();
  }

  Future<void> requestCurrentLocation() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_service.getCurrentLocation);
  }
}

final locationProvider = AsyncNotifierProvider<LocationNotifier, Position?>(
  LocationNotifier.new,
);
