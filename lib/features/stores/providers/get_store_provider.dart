import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/stores/models/store.dart';
import 'package:go_to_save_app/features/stores/providers/store_repository_provider.dart';

class GetStoreNotifier extends AsyncNotifier<Store> {
  final String storeId;

  GetStoreNotifier(this.storeId);

  @override
  FutureOr<Store> build() => _fetch(storeId);

  Future<Store> _fetch(String storeId) {
    final repo = ref.read(storeRepositoryProvider);
    return repo.getStore(storeId);
  }

  Future<void> refresh() async {
    final result = await AsyncValue.guard(() => _fetch(storeId));
    if (ref.mounted) state = result;
  }
}

final getStoreProvider = AsyncNotifierProvider.autoDispose
    .family<GetStoreNotifier, Store, String>(GetStoreNotifier.new);
