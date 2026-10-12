import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/geolocation/location_provider.dart';
import 'package:go_to_save_app/core/geolocation/location_service.dart';
import 'package:go_to_save_app/core/http/resolve_media_url.dart';
import 'package:go_to_save_app/features/stores/models/rating.dart';
import 'package:go_to_save_app/features/stores/models/store_summary.dart';
import 'package:go_to_save_app/features/stores/providers/list_nearby_stores_provider.dart';
import 'package:go_to_save_app/features/stores/providers/radius_filter_provider.dart';
import 'package:go_to_save_app/features/stores/widgets/radius_filter_sheet.dart';
import 'package:go_to_save_app/shared/utils/format_currency_brl.dart';
import 'package:go_to_save_app/shared/widgets/error_state_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _openRadiusFilter(BuildContext context, WidgetRef ref) async {
    final currentRadius = ref.read(radiusFilterProvider);

    final selected = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => RadiusFilterSheet(selectedRadius: currentRadius),
    );

    if (selected != null) {
      ref.read(radiusFilterProvider.notifier).setRadius(selected);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: location.when(
          data: (position) {
            if (position == null) {
              return _EnableLocationPrompt(
                onPressed: () => ref
                    .read(locationProvider.notifier)
                    .requestCurrentLocation(),
              );
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mais próximas de você',
                      style: theme.textTheme.titleMedium,
                    ),
                    GestureDetector(
                      onTap: () => _openRadiusFilter(context, ref),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list_outlined,
                            size: 18,
                            color: colorScheme.primary,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            'Filtro',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Expanded(child: _StoresList()),
              ],
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
          error: (error, _) => _LocationErrorView(
            error: error,
            onRetry: () =>
                ref.read(locationProvider.notifier).requestCurrentLocation(),
          ),
        ),
      ),
    );
  }
}

class _EnableLocationPrompt extends StatelessWidget {
  final VoidCallback onPressed;

  const _EnableLocationPrompt({required this.onPressed});

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
              Icons.location_on_outlined,
              size: 48,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Ative sua localização para ver sacolas perto de você',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Ativar localização'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _LocationErrorView({required this.error, required this.onRetry});

  IconData get _icon {
    if (error is AppLocationServiceDisabledException) {
      return Icons.location_off_outlined;
    }
    if (error is AppLocationPermissionDeniedException ||
        error is AppLocationPermissionDeniedForeverException) {
      return Icons.location_disabled_outlined;
    }

    return Icons.error_outlined;
  }

  String get _message {
    if (error is AppLocationServiceDisabledException) {
      return 'Ative a localização do seu aparelho para ver lojas próximas.';
    }
    if (error is AppLocationPermissionDeniedException) {
      return 'Precisamos da sua localização para mostrar lojas próximas.';
    }
    if (error is AppLocationPermissionDeniedForeverException) {
      return 'A permissão de localização foi negada. Ative-a nas configurações do app.';
    }

    return 'Não foi possível carregar as lojas próximas.';
  }

  bool get _isDeniedForever =>
      error is AppLocationPermissionDeniedForeverException;

  @override
  Widget build(BuildContext context) {
    return ErrorStateView(
      icon: _icon,
      message: _message,
      actionLabel: _isDeniedForever
          ? 'Abrir configurações'
          : 'Tentar novamente',
      onAction: _isDeniedForever ? () => Geolocator.openAppSettings() : onRetry,
    );
  }
}

class _StoresList extends ConsumerWidget {
  const _StoresList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(listNearbyStoresProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      color: colorScheme.primary,
      onRefresh: () => ref.read(listNearbyStoresProvider.notifier).refresh(),
      child: storesAsync.when(
        data: (stores) {
          if (stores.isEmpty) {
            return ErrorStateView(
              icon: Icons.search_off_outlined,
              message: 'Nenhuma loja próxima localizada.',
              actionLabel: 'Recarregar',
              onAction: () =>
                  ref.read(listNearbyStoresProvider.notifier).refresh(),
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: stores.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  _StoreCard(
                    store: stores[index],
                    onTap: () => context.push('/stores/${stores[index].id}'),
                  ),
                ],
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
        error: (err, _) => Center(
          child: ErrorStateView(
            icon: Icons.wifi_off_outlined,
            message: 'Ocorreu um erro. Tente novamente mais tarde.',
            actionLabel: 'Tentar novamente',
            onAction: () =>
                ref.read(listNearbyStoresProvider.notifier).refresh(),
          ),
        ),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final StoreSummary store;
  final VoidCallback? onTap;

  const _StoreCard({required this.store, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedPrice = formatCurrencyBrl(store.bagsMinPriceInBRL);

    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StoreAvatar(store.avatarUrl),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children: [
                        _StoreRatingBadge(rating: store.rating),
                        Text(
                          ' • ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.inverseSurface,
                          ),
                        ),
                        Icon(
                          Icons.directions_run,
                          size: 16,
                          color: colorScheme.inverseSurface,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          '${store.distanceKm} Km',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.inverseSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.shopping_bag_outlined,
                          label:
                              '${store.bagsCount} ${store.bagsCount == 1 ? 'sacola' : 'sacolas'}',
                          labelColor: colorScheme.onPrimary,
                          color: colorScheme.primary,
                        ),

                        const SizedBox(width: 8),

                        _InfoChip(
                          label: 'Por até $formattedPrice',
                          labelColor: colorScheme.onPrimary,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color labelColor;
  final Color color;

  const _InfoChip({
    this.icon,
    required this.label,
    required this.labelColor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: icon != null
          ? Row(
              children: [
                Icon(icon, size: 16, color: labelColor),

                const SizedBox(width: 4),

                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}

class _StoreAvatar extends StatelessWidget {
  final String? avatarUrl;

  const _StoreAvatar(this.avatarUrl);

  Widget _fallback(ColorScheme colorScheme) {
    return Center(
      child: Icon(
        Icons.store_outlined,
        size: 32,
        color: colorScheme.inverseSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedUrl = resolveMediaUrl(avatarUrl);
    const double size = 64;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: colorScheme.surfaceContainerHigh,
        child: resolvedUrl != null
            ? Image.network(
                resolvedUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallback(colorScheme),
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
              )
            : _fallback(colorScheme),
      ),
    );
  }
}

class _StoreRatingBadge extends StatelessWidget {
  final Rating rating;

  const _StoreRatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!rating.hasRatings) {
      return Text(
        'Novo',
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.secondary,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 16, color: Colors.amber.shade600),
        const SizedBox(width: 4),
        Text(
          rating.average.toString(),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(' (${rating.count})', style: theme.textTheme.bodySmall),
      ],
    );
  }
}
