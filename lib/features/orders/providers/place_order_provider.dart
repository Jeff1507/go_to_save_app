import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/cart/providers/cart_provider.dart';
import 'package:go_to_save_app/features/orders/providers/order_repository_provider.dart';
import 'package:go_to_save_app/features/orders/providers/orders_list_provider.dart';

class PlaceOrderNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() => null;

  Future<String?> placeOrder() async {
    final cart = ref.read(cartProvider);
    assert(!cart.isEmpty, 'placeOrder chamado com o carrinho vazio');

    state = const AsyncLoading();

    String? orderId;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(orderRepositoryProvider);
      orderId = await repo.placeOrder(cart.items);
    });

    if (orderId != null) {
      ref.invalidate(ordersListProvider);
    }

    return orderId;
  }
}

final placeOrderProvider =
    AsyncNotifierProvider.autoDispose<PlaceOrderNotifier, void>(
      PlaceOrderNotifier.new,
    );
