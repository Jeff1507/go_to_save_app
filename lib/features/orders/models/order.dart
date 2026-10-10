import 'package:go_to_save_app/features/orders/models/order_status.dart';
import 'package:go_to_save_app/features/orders/models/order_summary.dart';
import 'package:go_to_save_app/features/orders/models/review.dart';
import 'package:go_to_save_app/features/stores/models/pickup_window.dart';

class Order {
  final String id;
  final OrderStatus status;
  final int totalPrice;
  final String confirmationCode;
  final DateTime createdAt;
  final DateTime? completedAt;
  final PickupWindow pickupWindow;
  final OrderStoreInfo store;
  final List<OrderBag> bags;
  final Review? review;

  Order({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.confirmationCode,
    required this.createdAt,
    this.completedAt,
    required this.pickupWindow,
    required this.store,
    required this.bags,
    this.review,
  });

  double get totalPriceInBRL => totalPrice / 100;

  bool get hasReview => review != null;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      status: OrderStatus.fromJson(json['status'] as String),
      totalPrice: json['totalPrice'] as int,
      confirmationCode: json['confirmationCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String).toLocal()
          : null,
      pickupWindow: PickupWindow.fromJson(
        json['pickupWindow'] as Map<String, dynamic>,
      ),
      store: OrderStoreInfo.fromJson(json['store'] as Map<String, dynamic>),
      bags: (json['bags'] as List)
          .map((e) => OrderBag.fromJson(e as Map<String, dynamic>))
          .toList(),
      review: json['review'] != null
          ? Review.fromJson(json['review'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OrderBag {
  final String id;
  final String title;
  final int quantity;
  final int unitPrice; // centavos
  final List<OrderBagItem> items;

  OrderBag({
    required this.id,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    required this.items,
  });

  double get unitPriceInBRL => unitPrice / 100;
  double get subtotalInBRL => (unitPrice * quantity) / 100;

  factory OrderBag.fromJson(Map<String, dynamic> json) {
    return OrderBag(
      id: json['id'] as String,
      title: json['title'] as String,
      quantity: json['quantity'] as int,
      unitPrice: json['unitPrice'] as int,
      items: (json['items'] as List)
          .map((e) => OrderBagItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderBagItem {
  final String id;
  final String name;
  final String? imageUrl;
  final int quantity;

  OrderBagItem({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.quantity,
  });

  factory OrderBagItem.fromJson(Map<String, dynamic> json) {
    return OrderBagItem(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      quantity: json['quantity'] as int,
    );
  }
}
