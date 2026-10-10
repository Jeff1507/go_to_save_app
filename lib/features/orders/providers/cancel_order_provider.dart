import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/orders/providers/order_detail_provider.dart';
import 'package:go_to_save_app/features/orders/providers/order_repository_provider.dart';
import 'package:go_to_save_app/features/orders/providers/orders_list_provider.dart';

class CancelOrderNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> cancelOrder(String id) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(orderRepositoryProvider);
      await repo.cancelOrder(id);
    });

    if (state.hasError) return;

    ref.invalidate(orderDetailProvider(id));
    ref.invalidate(ordersListProvider);
  }
}

final cancelOrderProvider =
    AsyncNotifierProvider.autoDispose<CancelOrderNotifier, void>(
      CancelOrderNotifier.new,
    );
