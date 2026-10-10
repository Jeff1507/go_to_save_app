import 'package:dio/dio.dart';
import 'package:go_to_save_app/core/http/api_runner.dart';
import 'package:go_to_save_app/features/cart/models/cart_item.dart';
import 'package:go_to_save_app/features/orders/models/order.dart';
import 'package:go_to_save_app/features/orders/models/order_summary.dart';

class OrderRepository {
  final Dio _api;

  OrderRepository(this._api);

  Future<String> placeOrder(List<CartItem> items) {
    return runApiCall(() async {
      final response = await _api.post(
        '/orders',
        data: {
          'items': items
              .map((item) => {'bagId': item.bag.id, 'quantity': item.quantity})
              .toList(),
        },
      );

      return response.data['id'] as String;
    });
  }

  Future<List<OrderSummary>> listOrders() {
    return runApiCall(() async {
      final response = await _api.get('/orders');
      return (response.data as List)
          .map((e) => OrderSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Order> getOrder(String id) {
    return runApiCall(() async {
      final response = await _api.get('/orders/$id');
      return Order.fromJson(response.data);
    });
  }

  Future<void> cancelOrder(String id) {
    return runApiCall(() async {
      await _api.patch('/orders/$id/cancel');
    });
  }

  Future<void> reviewOrder({
    required String orderId,
    required int rating,
    String? comment,
  }) {
    return runApiCall(() async {
      await _api.post(
        '/reviews/$orderId',
        data: {
          'rating': rating,
          if (comment != null && comment.isNotEmpty) 'comment': comment,
        },
      );
    });
  }
}
