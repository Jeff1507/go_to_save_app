import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/orders/models/order_summary.dart';
import 'package:go_to_save_app/features/orders/providers/order_repository_provider.dart';

class OrdersListNotifier extends AsyncNotifier<List<OrderSummary>> {
  @override
  Future<List<OrderSummary>> build() => _fetch();

  Future<List<OrderSummary>> _fetch() {
    final repo = ref.read(orderRepositoryProvider);
    return repo.listOrders();
  }

  Future<void> refresh() async {
    final result = await AsyncValue.guard(_fetch);
    if (ref.mounted) state = result;
  }
}

final ordersListProvider =
    AsyncNotifierProvider<OrdersListNotifier, List<OrderSummary>>(
      OrdersListNotifier.new,
    );
