import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/http/resolve_media_url.dart';
import 'package:go_to_save_app/features/cart/models/cart_conflict.dart';
import 'package:go_to_save_app/features/cart/models/cart_store_info.dart';
import 'package:go_to_save_app/features/cart/providers/cart_provider.dart';
import 'package:go_to_save_app/features/stores/models/bag.dart';
import 'package:go_to_save_app/features/stores/providers/get_bag_provider.dart';
import 'package:go_to_save_app/features/stores/utils/pickup_window_formatter.dart';
import 'package:go_to_save_app/features/stores/widgets/quantity_selector.dart';
import 'package:go_to_save_app/shared/widgets/confirmation_dialog.dart';
import 'package:go_to_save_app/shared/widgets/error_state_view.dart';
import 'package:go_to_save_app/shared/widgets/expandable_text.dart';
import 'package:go_to_save_app/shared/widgets/info_tile.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';
import 'package:intl/intl.dart';

class BagDetailScreen extends ConsumerWidget {
  final String bagId;
  final CartStoreInfo store;

  const BagDetailScreen({super.key, required this.bagId, required this.store});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bagAsync = ref.watch(getBagProvider(bagId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da sacola'),
        centerTitle: true,
      ),
      body: bagAsync.when(
        data: (bag) => _BagDetailContent(bag: bag),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorStateView(
          icon: Icons.error_outline,
          message: 'Não foi possível carregar a sacola.',
          actionLabel: 'Tentar novamente',
          onAction: () => ref.read(getBagProvider(bagId).notifier).refresh(),
        ),
      ),
      bottomNavigationBar: bagAsync.maybeWhen(
        data: (bag) => _AddToCartBar(bag: bag, store: store),
        orElse: () => null,
      ),
    );
  }
}

class _BagDetailContent extends StatelessWidget {
  final Bag bag;

  const _BagDetailContent({required this.bag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final priceFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(bag.title, style: theme.textTheme.headlineSmall),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  priceFormat.format(bag.originalPriceInBRL),
                  style: theme.textTheme.labelSmall?.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  priceFormat.format(bag.finalPriceInBRL),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        ExpandableText(bag.description ?? 'Sem descrição'),

        const SizedBox(height: 20),

        InfoTile(
          icon: Icons.schedule_outlined,
          label: 'Retirada',
          value: PickupWindowFormatter.formatPickupWindowLabel(
            bag.pickupWindow,
          ),
        ),

        const SizedBox(height: 12),

        InfoTile(
          icon: Icons.inventory_2_outlined,
          label: 'Estoque',
          value: bag.isAvailable
              ? '${bag.stock} ${bag.stock == 1 ? 'unidade disponível' : 'unidades disponíveis'}'
              : 'Esgotado',
        ),

        const SizedBox(height: 24),

        Text('O que vem na sacola', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),

        for (final item in bag.items) ...[
          _BagItemTile(item: item),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _BagItemTile extends StatelessWidget {
  final BagItem item;

  const _BagItemTile({required this.item});

  Widget _bagItemImage(String? resolvedUrl, ColorScheme colorScheme) {
    const double width = 56;
    const double height = 56;

    if (resolvedUrl == null || resolvedUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colorScheme.surfaceContainerHigh,
        ),
        child: Icon(Icons.fastfood_outlined, size: 24),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.network(
          resolvedUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: colorScheme.surfaceContainerHigh,
            child: Icon(Icons.image_not_supported_outlined, size: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resolvedUrl = resolveMediaUrl(item.imageUrl);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: _bagItemImage(resolvedUrl, colorScheme),
      title: Text(item.name, style: theme.textTheme.titleSmall),
      subtitle: Text('x${item.quantity}', style: theme.textTheme.bodySmall),
    );
  }
}

class _AddToCartBar extends ConsumerStatefulWidget {
  final Bag bag;
  final CartStoreInfo store;

  const _AddToCartBar({required this.bag, required this.store});

  @override
  ConsumerState<_AddToCartBar> createState() => _AddToCartBarState();
}

class _AddToCartBarState extends ConsumerState<_AddToCartBar> {
  late int _quantity;
  late int _savedQuantity;

  @override
  void initState() {
    super.initState();
    final existingItem = ref.read(cartProvider).findByBagId(widget.bag.id);
    _quantity = existingItem?.quantity ?? 1;
    _savedQuantity = existingItem?.quantity ?? 0;
  }

  bool get _hasChanges => _quantity != _savedQuantity;

  Future<void> _addToCart(BuildContext context) async {
    final cart = ref.read(cartProvider.notifier);
    final alreadyInCart = _savedQuantity > 0;
    final conflict = cart.checkConflict(
      storeId: widget.store.id,
      pickupWindow: widget.bag.pickupWindow,
    );

    if (conflict != CartConflict.none) {
      final confirmed = await ConfirmationDialog.show(
        context,
        title: conflict == CartConflict.differentStore
            ? 'Trocar de loja?'
            : 'Trocar horário de retirada?',
        description: conflict == CartConflict.differentStore
            ? 'Seu carrinho tem itens de outra loja. Adicionar esta sacola vai esvaziar o carrinho atual.'
            : 'Seu carrinho tem itens com outro horário de retirada. Adicionar esta sacola vai esvaziar o carrinho atual.',
        confirmLabel: 'Trocar',
        isDestructive: true,
      );

      if (!confirmed) return;

      cart.addItem(
        store: widget.store,
        bag: widget.bag,
        quantity: _quantity,
        replaceExisting: true,
      );
    } else if (alreadyInCart) {
      cart.updateQuantity(widget.bag.id, _quantity);
    } else {
      cart.addItem(store: widget.store, bag: widget.bag, quantity: _quantity);
    }

    setState(() => _savedQuantity = _quantity);

    if (context.mounted) {
      Toast.success(
        context,
        alreadyInCart ? 'Carrinho atualizado!' : 'Adicionado ao carrinho!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final priceFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final total = widget.bag.finalPriceInBRL * _quantity;
    final canSubmit = widget.bag.isAvailable && _hasChanges;

    final addToCartButtonLabel = !widget.bag.isAvailable
        ? 'Esgotado'
        : _savedQuantity == 0
        ? 'Adicionar ao carrinho'
        : _hasChanges
        ? 'Atualizar carrinho'
        : 'Já no carrinho';

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: theme.textTheme.titleMedium),
                Text(
                  priceFormat.format(total),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuantitySelector(
                  quantity: _quantity,
                  maxQuantity: widget.bag.stock,
                  onChanged: (value) => setState(() => _quantity = value),
                ),

                FilledButton.icon(
                  onPressed: canSubmit ? () => _addToCart(context) : null,
                  icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                  label: Text(addToCartButtonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
