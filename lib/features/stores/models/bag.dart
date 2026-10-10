import 'package:go_to_save_app/features/stores/models/pickup_window.dart';

class Bag {
  final String id;
  final String title;
  final String? description;
  final int stock;
  final int discount;
  final int originalPrice;
  final int finalPrice;
  final PickupWindow pickupWindow;
  final List<BagItem> items;

  Bag({
    required this.id,
    required this.title,
    this.description,
    required this.stock,
    required this.discount,
    required this.originalPrice,
    required this.finalPrice,
    required this.pickupWindow,
    required this.items,
  });

  bool get isAvailable => stock > 0;

  double get originalPriceInBRL => originalPrice / 100;

  double get finalPriceInBRL => finalPrice / 100;

  factory Bag.fromJson(Map<String, dynamic> json) {
    return Bag(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      stock: json['stock'] as int,
      discount: json['discount'] as int,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      pickupWindow: PickupWindow.fromJson(
        json['pickupWindow'] as Map<String, dynamic>,
      ),
      items: (json['items'] as List)
          .map((e) => BagItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BagItem {
  final String id;
  final String name;
  final String? imageUrl;
  final int quantity;

  BagItem({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.quantity,
  });

  factory BagItem.fromJson(Map<String, dynamic> json) {
    return BagItem(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      quantity: json['quantity'] as int,
    );
  }
}
