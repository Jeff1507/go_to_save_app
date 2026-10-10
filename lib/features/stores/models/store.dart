import 'package:go_to_save_app/features/stores/models/address.dart';
import 'package:go_to_save_app/features/stores/models/pickup_window.dart';
import 'package:go_to_save_app/features/stores/models/rating.dart';

class Store {
  final String id;
  final String name;
  final String cnpj;
  final String? avatarUrl;
  final String? description;
  final DateTime createdAt;
  final Rating rating;
  final Address address;
  final List<BagSummary> bags;

  Store({
    required this.id,
    required this.name,
    required this.cnpj,
    this.avatarUrl,
    this.description,
    required this.createdAt,
    required this.rating,
    required this.address,
    required this.bags,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as String,
      name: json['name'] as String,
      cnpj: json['cnpj'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      bags: (json['bags'] as List)
          .map((e) => BagSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BagSummary {
  final String id;
  final String title;
  final String? description;
  final int stock;
  final int discount;
  final int originalPrice; // em centavos
  final int finalPrice; // em centavos
  final PickupWindow pickupWindow;

  BagSummary({
    required this.id,
    required this.title,
    this.description,
    required this.stock,
    required this.discount,
    required this.originalPrice,
    required this.finalPrice,
    required this.pickupWindow,
  });

  bool get isAvailable => stock > 0;

  double get originalPriceInBRL => originalPrice / 100;

  double get finalPriceInBRL => finalPrice / 100;

  factory BagSummary.fromJson(Map<String, dynamic> json) {
    return BagSummary(
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
    );
  }
}
