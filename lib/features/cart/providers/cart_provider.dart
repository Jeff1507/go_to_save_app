import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/cart/models/cart_conflict.dart';
import 'package:go_to_save_app/features/cart/models/cart_item.dart';
import 'package:go_to_save_app/features/cart/models/cart_state.dart';
import 'package:go_to_save_app/features/cart/models/cart_store_info.dart';
import 'package:go_to_save_app/features/stores/models/bag.dart';
import 'package:go_to_save_app/features/stores/models/pickup_window.dart';

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  CartConflict checkConflict({
    required String storeId,
    required PickupWindow pickupWindow,
  }) {
    if (state.isEmpty) return CartConflict.none;

    if (state.store?.id != storeId) {
      return CartConflict.differentStore;
    }

    final currentWindow = state.items.first.bag.pickupWindow;
    if (currentWindow != pickupWindow) {
      return CartConflict.differentPickupWindow;
    }

    return CartConflict.none;
  }

  void addItem({
    required CartStoreInfo store,
    required Bag bag,
    required int quantity,
    bool replaceExisting = false,
  }) {
    final baseItems = replaceExisting ? <CartItem>[] : state.items;
    final existingIndex = baseItems.indexWhere((i) => i.bag.id == bag.id);

    final List<CartItem> updatedItems;
    if (existingIndex >= 0) {
      final existing = baseItems[existingIndex];
      final newQuantity = (existing.quantity + quantity).clamp(
        1,
        existing.bag.stock,
      );
      updatedItems = [...baseItems]
        ..[existingIndex] = existing.copyWith(quantity: newQuantity);
    } else {
      updatedItems = [...baseItems, CartItem(bag: bag, quantity: quantity)];
    }

    state = CartState(store: store, items: updatedItems);
  }

  void updateQuantity(String bagId, int quantity) {
    final updated = state.items.map((item) {
      if (item.bag.id != bagId) return item;
      return item.copyWith(quantity: quantity.clamp(1, item.bag.stock));
    }).toList();

    state = CartState(store: state.store, items: updated);
  }

  void removeItem(String bagId) {
    final updated = state.items.where((i) => i.bag.id != bagId).toList();

    state = updated.isEmpty
        ? const CartState()
        : CartState(store: state.store, items: updated);
  }

  void clear() => state = const CartState();
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);
