import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/features/cart/models/cart_item.dart';
import 'package:go_to_save_app/features/cart/models/cart_state.dart';
import 'package:go_to_save_app/features/cart/models/cart_store_info.dart';
import 'package:go_to_save_app/features/cart/providers/cart_provider.dart';
import 'package:go_to_save_app/features/orders/providers/place_order_provider.dart';
import 'package:go_to_save_app/features/stores/utils/pickup_window_formatter.dart';
import 'package:go_to_save_app/features/stores/widgets/quantity_selector.dart';
import 'package:go_to_save_app/shared/widgets/confirmation_dialog.dart';
import 'package:go_to_save_app/shared/widgets/info_tile.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';
import 'package:go_to_save_app/shared/widgets/user_avatar.dart';
import 'package:intl/intl.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () async {
                final confirmed = await ConfirmationDialog.show(
                  context,
                  title: 'Esvaziar carrinho?',
                  description: 'Todos os itens serão removidos.',
                  confirmLabel: 'Esvaziar',
                  isDestructive: true,
                );
                if (confirmed) {
                  ref.read(cartProvider.notifier).clear();
                }
              },
              child: const Text('Limpar'),
            ),
        ],
      ),
      body: cart.isEmpty
          ? const _EmptyCart()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StoreHeader(store: cart.store!),

                  const SizedBox(height: 24),

                  InfoTile(
                    icon: Icons.schedule_outlined,
                    label: 'Retirada',
                    value: PickupWindowFormatter.formatPickupWindowLabel(
                      cart.items.first.bag.pickupWindow,
                    ),
                  ),

                  const SizedBox(height: 12),

                  InfoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Endereço',
                    value: cart.store!.address.formatted,
                  ),

                  const SizedBox(height: 24),

                  Text('Itens adicionados', style: theme.textTheme.titleMedium),

                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.separated(
                      itemCount: cart.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _CartItemTile(
                        store: cart.store!,
                        item: cart.items[index],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: cart.isEmpty ? null : _CheckoutBar(cart: cart),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  final CartStoreInfo store;

  const _StoreHeader({required this.store});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorSheme = theme.colorScheme;

    return Row(
      children: [
        UserAvatar(store.avatarUrl, size: 64),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(store.name, style: theme.textTheme.titleMedium),

              const SizedBox(height: 2),

              GestureDetector(
                onTap: () => context.push('/stores/${store.id}'),
                child: Text(
                  'Adicionar mais itens',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorSheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  final CartStoreInfo store;
  final CartItem item;

  const _CartItemTile({required this.store, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final priceFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Dismissible(
      key: ValueKey(item.bag.id),
      direction: DismissDirection.endToStart,
      background: _RemoveBackground(),
      confirmDismiss: (direction) async {
        return await ConfirmationDialog.show(
          context,
          title: 'Remover item?',
          description: 'Deseja remover "${item.bag.title}" do carrinho?',
          confirmLabel: 'Remover',
          isDestructive: true,
        );
      },
      onDismissed: (direction) {
        ref.read(cartProvider.notifier).removeItem(item.bag.id);
      },
      child: GestureDetector(
        onTap: () => context.push(
          '/bags/${item.bag.id}',
          extra: {
            'store': CartStoreInfo(
              id: store.id,
              name: store.name,
              avatarUrl: store.avatarUrl,
              address: store.address,
            ),
          },
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.bag.title, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(priceFormat.format(item.subtotalInBRL)),
                    ],
                  ),
                ),

                QuantitySelector(
                  quantity: item.quantity,
                  maxQuantity: item.bag.stock,
                  onChanged: (value) => ref
                      .read(cartProvider.notifier)
                      .updateQuantity(item.bag.id, value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RemoveBackground extends StatelessWidget {
  const _RemoveBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.delete_outline,
        color: colorScheme.surfaceContainerLowest,
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text('Seu carrinho está vazio', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Adicione sacolas de uma loja para começar',
              style: TextStyle(color: colorScheme.secondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutBar extends ConsumerWidget {
  final CartState cart;

  const _CheckoutBar({required this.cart});

  Future<void> _handlePlaceOrder(BuildContext context, WidgetRef ref) async {
    final cart = ref.read(cartProvider.notifier);
    final orderId = await ref.read(placeOrderProvider.notifier).placeOrder();

    if (!context.mounted) return;

    if (orderId == null) {
      final error = ref.read(placeOrderProvider).error;
      final message = error is ApiException
          ? error.message
          : 'Não foi possível concluir a reserva.';

      Toast.error(context, message);
      return;
    }

    Toast.success(context, 'Reserva realizada com sucesso!');

    context.go('/orders');
    context.push('/orders/$orderId');

    cart.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeOrder = ref.watch(placeOrderProvider);
    final isLoading = placeOrder.isLoading;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final priceFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cart.totalItemsCount} ${cart.totalItemsCount == 1 ? 'item' : 'itens'}',
                  ),
                  Text(
                    priceFormat.format(cart.totalPriceInReais),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: isLoading
                  ? null
                  : () => _handlePlaceOrder(context, ref),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Fazer pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
