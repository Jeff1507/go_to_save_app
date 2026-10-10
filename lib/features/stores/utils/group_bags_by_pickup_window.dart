import 'package:collection/collection.dart';
import 'package:go_to_save_app/features/stores/models/pickup_window.dart';
import 'package:go_to_save_app/features/stores/models/store.dart';

Map<PickupWindow, List<BagSummary>> groupBagsByPickupWindow(
  List<BagSummary> bags,
) {
  final grouped = groupBy(bags, (BagSummary bag) => bag.pickupWindow);

  final sortedEntries = grouped.entries.toList()
    ..sort((a, b) => a.key.start.compareTo(b.key.start));

  return Map.fromEntries(sortedEntries);
}
