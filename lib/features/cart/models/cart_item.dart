import 'package:go_to_save_app/features/stores/models/bag.dart';

class CartItem {
  final Bag bag;
  final int quantity;

  CartItem({required this.bag, required this.quantity});

  double get unitPriceInBRL => bag.finalPriceInBRL;
  double get subtotalInBRL => (bag.finalPriceInBRL * quantity);

  CartItem copyWith({int? quantity}) {
    return CartItem(bag: bag, quantity: quantity ?? this.quantity);
  }
}
