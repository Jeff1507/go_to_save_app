import 'package:go_to_save_app/features/stores/models/address.dart';
import 'package:go_to_save_app/features/stores/models/rating.dart';

class StoreSummary {
  final String id;
  final String name;
  final String cnpj;
  final String? avatarUrl;
  final String? description;
  final int bagsCount;
  final int bagsMinPrice;
  final double distanceKm;
  final DateTime createdAt;
  final Rating rating;
  final Address address;

  StoreSummary({
    required this.id,
    required this.name,
    required this.cnpj,
    this.avatarUrl,
    this.description,
    required this.bagsCount,
    required this.bagsMinPrice,
    required this.distanceKm,
    required this.createdAt,
    required this.rating,
    required this.address,
  });

  double get bagsMinPriceInBRL => bagsMinPrice / 100;

  factory StoreSummary.fromJson(Map<String, dynamic> json) {
    return StoreSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      cnpj: json['cnpj'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      description: json['description'] as String?,
      bagsCount: json['bagsCount'] as int,
      bagsMinPrice: json['bagsMinPrice'] as int,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
    );
  }
}
