import 'package:go_to_save_app/features/cart/models/cart_item.dart';
import 'package:go_to_save_app/features/cart/models/cart_store_info.dart';

class CartState {
  final CartStoreInfo? store;
  final List<CartItem> items;

  const CartState({this.store, this.items = const []});

  bool get isEmpty => items.isEmpty;

  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPriceInReais =>
      items.fold(0.0, (sum, item) => sum + item.subtotalInBRL);

  CartItem? findByBagId(String bagId) =>
      items.where((i) => i.bag.id == bagId).firstOrNull;
}
