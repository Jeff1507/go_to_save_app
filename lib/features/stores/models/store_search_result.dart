import 'package:go_to_save_app/features/stores/models/address.dart';
import 'package:go_to_save_app/features/stores/models/rating.dart';

class StoreSearchResult {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? description;
  final Rating rating;
  final Address address;

  StoreSearchResult({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.description,
    required this.rating,
    required this.address,
  });

  factory StoreSearchResult.fromJson(Map<String, dynamic> json) {
    return StoreSearchResult(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      description: json['description'] as String?,
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
    );
  }
}
