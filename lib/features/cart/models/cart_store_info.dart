import 'package:go_to_save_app/features/stores/models/address.dart';

class CartStoreInfo {
  final String id;
  final String name;
  final String? avatarUrl;
  final Address address;

  CartStoreInfo({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.address,
  });
}
