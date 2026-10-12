import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/features/cart/models/cart_store_info.dart';
import 'package:go_to_save_app/features/stores/models/store.dart';
import 'package:go_to_save_app/features/stores/providers/get_store_provider.dart';
import 'package:go_to_save_app/features/stores/utils/pickup_window_formatter.dart';
import 'package:go_to_save_app/features/stores/utils/group_bags_by_pickup_window.dart';
import 'package:go_to_save_app/shared/utils/format_currency_brl.dart';
import 'package:go_to_save_app/shared/widgets/error_state_view.dart';
import 'package:go_to_save_app/shared/widgets/expandable_text.dart';
import 'package:go_to_save_app/shared/widgets/info_tile.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';
import 'package:go_to_save_app/shared/widgets/user_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetailScreen extends ConsumerWidget {
  final String storeId;

  const StoreDetailScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeAsync = ref.watch(getStoreProvider(storeId));

    return Scaffold(
      body: storeAsync.when(
        data: (store) => _StoreDetailContent(store: store),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Scaffold(
          appBar: AppBar(),
          body: ErrorStateView(
            icon: Icons.error_outline,
            message: 'Não foi possível carregar a loja.',
            actionLabel: 'Tentar novamente',
            onAction: () =>
                ref.read(getStoreProvider(storeId).notifier).refresh(),
          ),
        ),
      ),
    );
  }
}

class _StoreDetailContent extends StatefulWidget {
  final Store store;

  const _StoreDetailContent({required this.store});

  @override
  State<_StoreDetailContent> createState() => _StoreDetailContentState();
}

class _StoreDetailContentState extends State<_StoreDetailContent> {
  final _scrollController = ScrollController();
  bool _showTitle = false;

  static const _expandedHeight = 240.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final threshold = _expandedHeight - kToolbarHeight;
    final shouldShow = _scrollController.offset > threshold;

    if (shouldShow != _showTitle) {
      setState(() => _showTitle = shouldShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final groupedBags = groupBagsByPickupWindow(widget.store.bags);

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: _expandedHeight,
          title: AnimatedOpacity(
            opacity: _showTitle ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Text(widget.store.name),
          ),
          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: colorScheme.surfaceContainer,
              child: SafeArea(child: _StoreHeader(store: store)),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (store.description != null) ...[
                  ExpandableText(store.description ?? 'Sem descrição'),
                  const SizedBox(height: 20),
                ],

                _StoreAddressCard(store: store),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Sacolas disponíveis',
              style: theme.textTheme.titleMedium,
            ),
          ),
        ),

        if (groupedBags.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Nenhuma sacola disponível no momento.',
                style: TextStyle(color: colorScheme.secondary),
              ),
            ),
          )
        else
          for (final entry in groupedBags.entries) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Icon(Icons.schedule_outlined, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      PickupWindowFormatter.formatPickupWindowLabel(entry.key),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: entry.value.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final bag = entry.value[index];

                  return _BagCard(
                    bag: bag,
                    onTap: () => context.push(
                      '/bags/${bag.id}',
                      extra: {
                        'store': CartStoreInfo(
                          id: store.id,
                          name: store.name,
                          avatarUrl: store.avatarUrl,
                          address: store.address,
                        ),
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _StoreHeader extends StatelessWidget {
  final Store store;

  const _StoreHeader({required this.store});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        SizedBox(height: kToolbarHeight),

        UserAvatar(store.avatarUrl, size: 92),

        const SizedBox(height: 12),

        Text(store.name, style: theme.textTheme.titleMedium),

        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (store.rating.hasRatings) ...[
              Icon(Icons.star_rounded, size: 18, color: Colors.amber.shade600),

              const SizedBox(width: 4),

              Text(
                store.rating.average.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' (${store.rating.count} avaliações)',
                style: theme.textTheme.bodyMedium,
              ),
            ] else
              Text(
                'Sem avaliações.',
                style: TextStyle(
                  color: colorScheme.secondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _StoreAddressCard extends StatelessWidget {
  final Store store;

  const _StoreAddressCard({required this.store});

  Future<void> _openMap(BuildContext context) async {
    final address = store.address;

    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '${address.latitude},${address.longitude}',
    });

    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}

    if (!opened && context.mounted) {
      Toast.error(context, 'Não foi possível abrir o mapa.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openMap(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: InfoTile(
            icon: Icons.location_on_outlined,
            label: 'Localização',
            value: store.address.formatted,
          ),
        ),
      ),
    );
  }
}

class _BagCard extends StatelessWidget {
  final BagSummary bag;
  final VoidCallback? onTap;

  const _BagCard({required this.bag, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: bag.isAvailable ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bag.title, style: theme.textTheme.titleMedium),

              const SizedBox(height: 8),

              Text(
                bag.description ?? 'Sem descrição.',
                style: theme.textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bag.isAvailable
                        ? '${bag.stock} ${bag.stock == 1 ? 'restante' : 'restantes'}'
                        : 'Esgotado',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: bag.isAvailable
                          ? colorScheme.secondary
                          : colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formatCurrencyBrl(bag.originalPriceInBRL),
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),

                      Text(
                        formatCurrencyBrl(bag.finalPriceInBRL),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
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
