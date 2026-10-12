import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/stores/models/store_search_result.dart';
import 'package:go_to_save_app/features/stores/providers/store_repository_provider.dart';

const minSearchLength = 2;

class StoreSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query.trim();
}

final storeSearchQueryProvider =
    NotifierProvider.autoDispose<StoreSearchQueryNotifier, String>(
      StoreSearchQueryNotifier.new,
    );

final storeSearchProvider = FutureProvider.autoDispose<List<StoreSearchResult>>(
  (ref) {
    final query = ref.watch(storeSearchQueryProvider);
    if (query.length < minSearchLength) return const [];

    return ref.read(storeRepositoryProvider).searchStores(query);
  },
);
