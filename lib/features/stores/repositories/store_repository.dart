import 'package:dio/dio.dart';
import 'package:go_to_save_app/core/http/api_runner.dart';
import 'package:go_to_save_app/features/stores/models/bag.dart';
import 'package:go_to_save_app/features/stores/models/store.dart';
import 'package:go_to_save_app/features/stores/models/store_search_result.dart';
import 'package:go_to_save_app/features/stores/models/store_summary.dart';

class StoreRepository {
  final Dio _api;

  const StoreRepository(this._api);

  Future<List<StoreSummary>> listNearbyStores({
    required double latitude,
    required double longitude,
    int radius = 5000,
  }) {
    return runApiCall(() async {
      final response = await _api.get(
        '/stores',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
        },
      );

      return (response.data as List)
          .map((data) => StoreSummary.fromJson(data as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Store> getStore(String id) {
    return runApiCall(() async {
      final response = await _api.get('/stores/$id');
      return Store.fromJson(response.data);
    });
  }

  Future<Bag> getBag(String id) {
    return runApiCall(() async {
      final response = await _api.get('/bags/$id');
      return Bag.fromJson(response.data);
    });
  }

  Future<List<StoreSearchResult>> searchStores(String name) {
    return runApiCall(() async {
      final response = await _api.get(
        '/stores/search',
        queryParameters: {'name': name},
      );

      return (response.data as List)
          .map((e) => StoreSearchResult.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}
