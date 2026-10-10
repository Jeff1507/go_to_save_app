import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/core/http/resolve_media_url.dart';
import 'package:go_to_save_app/features/orders/models/order.dart';
import 'package:go_to_save_app/features/orders/models/order_status.dart';
import 'package:go_to_save_app/features/orders/models/order_summary.dart';
import 'package:go_to_save_app/features/orders/models/review.dart';
import 'package:go_to_save_app/features/orders/providers/cancel_order_provider.dart';
import 'package:go_to_save_app/features/orders/providers/order_detail_provider.dart';
import 'package:go_to_save_app/features/orders/providers/review_order_provider.dart';
import 'package:go_to_save_app/features/orders/widgets/order_status_badge.dart';
import 'package:go_to_save_app/features/stores/utils/pickup_window_formatter.dart';
import 'package:go_to_save_app/shared/utils/format_currency_brl.dart';
import 'package:go_to_save_app/shared/widgets/confirmation_dialog.dart';
import 'package:go_to_save_app/shared/widgets/error_alert.dart';
import 'package:go_to_save_app/shared/widgets/error_state_view.dart';
import 'package:go_to_save_app/shared/widgets/info_tile.dart';
import 'package:go_to_save_app/shared/widgets/loading_button.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';
import 'package:go_to_save_app/shared/widgets/user_avatar.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do pedido'),
        centerTitle: true,
      ),
      body: orderAsync.when(
        data: (order) => RefreshIndicator(
          onRefresh: () =>
              ref.read(orderDetailProvider(orderId).notifier).refresh(),
          child: _OrderDetailContent(order: order),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorStateView(
          icon: Icons.error_outline,
          message: 'Não foi possível carregar o pedido.',
          actionLabel: 'Tentar novamente',
          onAction: () =>
              ref.read(orderDetailProvider(orderId).notifier).refresh(),
        ),
      ),
    );
  }
}

class _OrderDetailContent extends ConsumerWidget {
  final Order order;

  const _OrderDetailContent({required this.order});

  Future<void> _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Cancelar pedido?',
      description: 'Tem certeza que deseja cancelar o pedido. Esta ação não pode ser desfeita.',
      confirmLabel: 'Cancelar',
      isDestructive: true,
    );
    if (!confirmed) return;

    await ref.read(cancelOrderProvider.notifier).cancelOrder(order.id);
  }

  void _showError(BuildContext context, AsyncValue<void> value) {
    final error = value.error;
    if (error == null) return;

    final message = error is ApiException
        ? error.message
        : 'Algo deu errado. Tente novamente.';

    Toast.error(context, message);
  }

  Future<void> _reviewOrder(BuildContext context) async {
    final reviewed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ReviewOrderSheet(orderId: order.id),
    );

    if (reviewed == true && context.mounted) {
      Toast.success(context, 'Avaliação enviada com sucesso!');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isCancelling = ref.watch(cancelOrderProvider).isLoading;
    final isPending = order.status == OrderStatus.pending;
    final canReview = order.status == OrderStatus.completed && !order.hasReview;

    ref.listen<AsyncValue<void>>(cancelOrderProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasError) {
        _showError(context, next);
      }
    });

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: OrderStatusBadge(status: order.status),
        ),

        const SizedBox(height: 16),

        if (isPending) ...[
          _ConfirmationCodeCard(code: order.confirmationCode),

          const SizedBox(height: 16),
        ],

        Text('Estabelecimento', style: theme.textTheme.titleMedium),

        const SizedBox(height: 12),

        _StoreCard(store: order.store),

        const SizedBox(height: 16),

        Text('Sacolas', style: theme.textTheme.titleMedium),

        const SizedBox(height: 12),

        for (final bag in order.bags) ...[
          _OrderBagCard(bag: bag),

          const SizedBox(height: 12),
        ],

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: theme.textTheme.titleMedium),
            Text(
              formatCurrencyBrl(order.totalPriceInBRL),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Divider(),

        const SizedBox(height: 12),

        if (isPending) ...[
          InfoTile(
            icon: Icons.schedule_outlined,
            label: 'Retirada',
            value: PickupWindowFormatter.formatPickupWindowLabel(
              order.pickupWindow,
            ),
          ),

          const SizedBox(height: 12),
        ],

        InfoTile(
          icon: Icons.receipt_long_outlined,
          label: 'Pedido feito em',
          value: DateFormat(
            "dd/MM/yyyy 'às' HH:mm",
            'pt_BR',
          ).format(order.createdAt),
        ),
        if (order.completedAt != null) ...[
          const SizedBox(height: 12),
          InfoTile(
            icon: Icons.check_circle_outline,
            label: 'Concluído em',
            value: DateFormat(
              "dd/MM/yyyy 'às' HH:mm",
              'pt_BR',
            ).format(order.completedAt!),
          ),
        ],

        if (isPending) ...[
          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: isCancelling ? null : () => _cancelOrder(context, ref),
            icon: isCancelling ? null : const Icon(Icons.close),
            label: isCancelling
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Cancelar pedido'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
          ),
        ],

        if (order.review != null) ...[
          const SizedBox(height: 24),
          Text('Sua avaliação', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _ReviewCard(review: order.review!),
        ],

        if (canReview) ...[
          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: () => _reviewOrder(context),
            icon: const Icon(Icons.star_outline),
            label: const Text('Avaliar pedido'),
          ),
        ],
      ],
    );
  }
}

class _StarRatingInput extends StatelessWidget {
  final int rating;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const _StarRatingInput({
    required this.rating,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final value = index + 1;
        final selected = value <= rating;

        return IconButton(
          onPressed: enabled ? () => onChanged(value) : null,
          iconSize: 36,
          icon: Icon(
            selected ? Icons.star_rounded : Icons.star_outline_rounded,
            color: selected ? Colors.amber.shade600 : colorScheme.outline,
          ),
        );
      }),
    );
  }
}

class ReviewOrderSheet extends ConsumerStatefulWidget {
  final String orderId;

  const ReviewOrderSheet({super.key, required this.orderId});

  @override
  ConsumerState<ReviewOrderSheet> createState() => _ReviewOrderSheetState();
}

class _ReviewOrderSheetState extends ConsumerState<ReviewOrderSheet> {
  final _commentController = TextEditingController();
  int _rating = 0;
  String? _ratingError;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      setState(() => _ratingError = 'Selecione uma nota');
      return;
    }

    final success = await ref
        .read(reviewOrderProvider.notifier)
        .reviewOrder(
          orderId: widget.orderId,
          rating: _rating,
          comment: _commentController.text.trim(),
        );

    if (!mounted) return;

    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final review = ref.watch(reviewOrderProvider);
    final isLoading = review.isLoading;
    final error = review.error;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: !isLoading,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Avaliar pedido',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),

                const SizedBox(height: 16),

                if (error is ApiException) ErrorAlert(error.message),

                _StarRatingInput(
                  rating: _rating,
                  enabled: !isLoading,
                  onChanged: (value) => setState(() {
                    _rating = value;
                    _ratingError = null;
                  }),
                ),

                if (_ratingError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _ratingError!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                TextField(
                  controller: _commentController,
                  enabled: !isLoading,
                  maxLines: 5,
                  maxLength: 255,
                  textCapitalization: TextCapitalization.sentences,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    labelText: 'Comentário (opcional)',
                    labelStyle: theme.textTheme.bodyMedium,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                LoadingButton(
                  label: 'Enviar avaliação',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 1; i <= 5; i++)
              Icon(
                i <= review.rating
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                size: 22,
                color: i <= review.rating
                    ? Colors.amber.shade600
                    : colorScheme.outline,
              ),
            const Spacer(),
            Text(
              DateFormat('dd/MM/yyyy', 'pt_BR').format(review.reviewedAt),
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
        if (review.hasComment) ...[
          const SizedBox(height: 12),
          Text(review.comment!),
        ],
      ],
    );
  }
}

class _ConfirmationCodeCard extends StatelessWidget {
  final String code;

  const _ConfirmationCodeCard({required this.code});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Código de retirada',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 12,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Apresente este código na loja para retirar seu pedido.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.inverseSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final OrderStoreInfo store;

  const _StoreCard({required this.store});

  Future<void> _openMap() async {
    debugPrint('Abriu o mapa');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _openMap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              UserAvatar(store.avatarUrl, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.name, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      store.address.formatted,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.directions_outlined, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderBagCard extends StatelessWidget {
  final OrderBag bag;

  const _OrderBagCard({required this.bag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            '${bag.quantity}x ${bag.title}',
            style: theme.textTheme.titleSmall,
          ),
          subtitle: Text(
            formatCurrencyBrl(bag.subtotalInBRL),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          children: [for (final item in bag.items) _OrderItemRow(item: item)],
        ),
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderBagItem item;

  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resolvedUrl = resolveMediaUrl(item.imageUrl);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 40,
              height: 40,
              child: resolvedUrl != null
                  ? Image.network(
                      resolvedUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: colorScheme.surfaceContainerHigh,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 18,
                        ),
                      ),
                    )
                  : Container(
                      color: colorScheme.surfaceContainerHigh,
                      child: const Icon(Icons.fastfood_outlined, size: 18),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(item.name, style: theme.textTheme.bodyMedium)),
          Text('x${item.quantity}', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
