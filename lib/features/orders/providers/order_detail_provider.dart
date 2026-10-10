import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/orders/models/order.dart';
import 'package:go_to_save_app/features/orders/providers/order_repository_provider.dart';

class OrderDetailNotifier extends AsyncNotifier<Order> {
  final String orderId;

  OrderDetailNotifier(this.orderId);

  @override
  FutureOr<Order> build() => _fetch(orderId);

  Future<Order> _fetch(String orderId) {
    final repo = ref.read(orderRepositoryProvider);
    return repo.getOrder(orderId);
  }

  Future<void> refresh() async {
    final result = await AsyncValue.guard(() => _fetch(orderId));
    if (ref.mounted) state = result;
  }
}

final orderDetailProvider = AsyncNotifierProvider.autoDispose
    .family<OrderDetailNotifier, Order, String>(OrderDetailNotifier.new);
