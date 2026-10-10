import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/geolocation/location_provider.dart';
import 'package:go_to_save_app/features/stores/providers/radius_filter_provider.dart';
import 'package:go_to_save_app/features/stores/models/store_summary.dart';
import 'package:go_to_save_app/features/stores/providers/store_repository_provider.dart';

class ListNearbyStoresNotifier extends AsyncNotifier<List<StoreSummary>> {
  @override
  Future<List<StoreSummary>> build() => _fetch();

  Future<List<StoreSummary>> _fetch() async {
    final position = await ref.watch(locationProvider.future);
    if (position == null) return [];

    final radius = ref.watch(radiusFilterProvider);

    final repo = ref.read(storeRepositoryProvider);
    return repo.listNearbyStores(
      latitude: position.latitude,
      longitude: position.longitude,
      radius: radius,
    );
  }

  Future<void> refresh() async {
    final result = await AsyncValue.guard(_fetch);
    if (ref.mounted) {
      state = result;
    }
  }
}

final listNearbyStoresProvider =
    AsyncNotifierProvider<ListNearbyStoresNotifier, List<StoreSummary>>(
      ListNearbyStoresNotifier.new,
    );
