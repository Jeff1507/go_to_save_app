import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/stores/models/bag.dart';
import 'package:go_to_save_app/features/stores/providers/store_repository_provider.dart';

class GetBagNotifier extends AsyncNotifier<Bag> {
  final String bagId;

  GetBagNotifier(this.bagId);

  @override
  FutureOr<Bag> build() => _fetch(bagId);

  Future<Bag> _fetch(String bagId) {
    final repo = ref.read(storeRepositoryProvider);
    return repo.getBag(bagId);
  }

  Future<void> refresh() async {
    final result = await AsyncValue.guard(() => _fetch(bagId));
    if (ref.mounted) state = result;
  }
}

final getBagProvider = AsyncNotifierProvider.autoDispose
    .family<GetBagNotifier, Bag, String>(GetBagNotifier.new);
