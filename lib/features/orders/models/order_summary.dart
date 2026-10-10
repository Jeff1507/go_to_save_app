import 'package:go_to_save_app/features/orders/models/order_status.dart';
import 'package:go_to_save_app/features/stores/models/address.dart';
import 'package:go_to_save_app/features/stores/models/pickup_window.dart';
import 'package:go_to_save_app/features/stores/models/rating.dart';

class OrderSummary {
  final String id;
  final OrderStatus status;
  final int totalPrice; // em centavos
  final DateTime createdAt;
  final DateTime? completedAt;
  final int totalItemsCount;
  final PickupWindow pickupWindow;
  final OrderStoreInfo store;

  OrderSummary({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.completedAt,
    required this.totalItemsCount,
    required this.pickupWindow,
    required this.store,
  });

  double get totalPriceInBRL => totalPrice / 100;

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      id: json['id'] as String,
      status: OrderStatus.fromJson(json['status'] as String),
      totalPrice: json['totalPrice'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String).toLocal()
          : null,
      totalItemsCount: json['itemsTotalCount'] as int,
      pickupWindow: PickupWindow.fromJson(
        json['pickupWindow'] as Map<String, dynamic>,
      ),
      store: OrderStoreInfo.fromJson(json['store'] as Map<String, dynamic>),
    );
  }
}

class OrderStoreInfo {
  final String id;
  final String name;
  final String? avatarUrl;
  final Rating rating;
  final Address address;

  OrderStoreInfo({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.rating,
    required this.address,
  });

  factory OrderStoreInfo.fromJson(Map<String, dynamic> json) {
    return OrderStoreInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
    );
  }
}
