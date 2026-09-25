import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_to_save_app/core/geolocation/get_current_location.dart';

class LocationNotifier extends AsyncNotifier<Position?> {
  @override
  FutureOr<Position?> build() {
    return getCurrentLocation();
  }

  Future<void> requestCurrentLocation() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(getCurrentLocation);
  }
}

final locationProvider = AsyncNotifierProvider<LocationNotifier, Position?>(
  LocationNotifier.new,
);
