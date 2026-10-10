import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/features/orders/models/order_status.dart';
import 'package:go_to_save_app/features/orders/models/order_summary.dart';
import 'package:go_to_save_app/features/orders/providers/orders_list_provider.dart';
import 'package:go_to_save_app/features/orders/widgets/order_status_badge.dart';
import 'package:go_to_save_app/features/stores/utils/pickup_window_formatter.dart';
import 'package:go_to_save_app/shared/utils/format_currency_brl.dart';
import 'package:go_to_save_app/shared/widgets/error_state_view.dart';
import 'package:go_to_save_app/shared/widgets/user_avatar.dart';
import 'package:intl/intl.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersListProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () => ref.read(ordersListProvider.notifier).refresh(),
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return _ScrollableCenteredContent(
                child: ErrorStateView(
                  icon: Icons.receipt_long_outlined,
                  message: 'Você ainda não fez nenhum pedido.',
                  actionLabel: 'Ver lojas próximas',
                  onAction: () => context.go('/home'),
                ),
              );
            }

            final currentOrder = orders
                .where((o) => o.status == OrderStatus.pending)
                .firstOrNull;
            final history = orders
                .where((o) => o.status != OrderStatus.pending)
                .toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (currentOrder != null) ...[
                  Text(
                    'Pedido atual',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _CurrentOrderCard(order: currentOrder),
                  const SizedBox(height: 24),
                ],
                if (history.isNotEmpty) ...[
                  Text(
                    'Histórico',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  for (final order in history) ...[
                    _OrderCard(order: order),
                    const SizedBox(height: 12),
                  ],
                ],
              ],
            );
          },
          loading: () => _ScrollableCenteredContent(
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
          error: (err, _) => _ScrollableCenteredContent(
            child: ErrorStateView(
              icon: Icons.wifi_off_outlined,
              message: 'Não foi possível carregar seus pedidos.',
              actionLabel: 'Tentar novamente',
              onAction: () => ref.read(ordersListProvider.notifier).refresh(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrollableCenteredContent extends StatelessWidget {
  final Widget child;
  const _ScrollableCenteredContent({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: Center(child: child),
            ),
          ],
        );
      },
    );
  }
}

class _CurrentOrderCard extends StatelessWidget {
  final OrderSummary order;

  const _CurrentOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final priceFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => context.push('/orders/${order.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    'Aguardando retirada',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  UserAvatar(order.store.avatarUrl, size: 56),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.store.name,
                          style: theme.textTheme.titleMedium,
                        ),

                        const SizedBox(height: 2),

                        Text(
                          order.store.address.formatted,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Divider(),

              const SizedBox(height: 16),

              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: colorScheme.onSurface,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      PickupWindowFormatter.formatPickupWindowLabel(
                        order.pickupWindow,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 16,
                    color: colorScheme.onSurface,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      '${order.totalItemsCount} ${order.totalItemsCount == 1 ? 'item' : 'itens'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    priceFormat.format(order.totalPriceInBRL),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderSummary order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => context.push('/orders/${order.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  UserAvatar(order.store.avatarUrl, size: 48),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.store.name,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          DateFormat(
                            'dd/MM, HH:mm',
                            'pt_BR',
                          ).format(order.createdAt),
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),

              const SizedBox(height: 12),

              const Divider(),

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 16,
                    color: colorScheme.onSurface,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      '${order.totalItemsCount} ${order.totalItemsCount == 1 ? 'item' : 'itens'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    formatCurrencyBrl(order.totalPriceInBRL),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
