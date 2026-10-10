import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadiusFilterNotifier extends Notifier<int> {
  static const defaultRadius = 5000;

  @override
  int build() => defaultRadius;

  void setRadius(int radiusInMeters) {
    state = radiusInMeters;
  }
}

final radiusFilterProvider = NotifierProvider<RadiusFilterNotifier, int>(
  RadiusFilterNotifier.new,
);
