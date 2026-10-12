import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/features/stores/models/rating.dart';
import 'package:go_to_save_app/features/stores/models/store_search_result.dart';
import 'package:go_to_save_app/features/stores/providers/store_search_provider.dart';
import 'package:go_to_save_app/shared/widgets/error_state_view.dart';
import 'package:go_to_save_app/shared/widgets/user_avatar.dart';

class StoreSearchScreen extends ConsumerStatefulWidget {
  const StoreSearchScreen({super.key});

  @override
  ConsumerState<StoreSearchScreen> createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends ConsumerState<StoreSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _applyQuery(String value) {
    ref.read(storeSearchQueryProvider.notifier).update(value);
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => _applyQuery(value),
    );
  }

  void _onSubmitted(String value) {
    _debounce?.cancel();
    _applyQuery(value);
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    _applyQuery('');
  }

  Widget _buildBody(String query) {
    if (query.length < minSearchLength) {
      return const _SearchMessage(
        icon: Icons.search,
        message: 'Busque lojas pelo nome',
      );
    }

    final results = ref.watch(storeSearchProvider);

    return Column(
      children: [
        if (results.isLoading && results.hasValue)
          const LinearProgressIndicator(),
        Expanded(
          child: results.when(
            skipLoadingOnReload: true,
            data: (stores) {
              if (stores.isEmpty) {
                return _SearchMessage(
                  icon: Icons.search_off_outlined,
                  message: 'Nenhuma loja encontrada para "$query".',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: stores.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final store = stores[index];

                  return _StoreSearchCard(
                    store: store,
                    onTap: () => context.push('/stores/${store.id}'),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => ErrorStateView(
              icon: Icons.wifi_off_outlined,
              message: 'Não foi possível realizar a busca.',
              actionLabel: 'Tentar novamente',
              onAction: () => ref.invalidate(storeSearchProvider),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(storeSearchQueryProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Buscar'), centerTitle: true),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) => SearchBar(
                  controller: _controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  hintText: 'Nome da loja',
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _clear,
                      ),
                  ],
                  elevation: const WidgetStatePropertyAll(0),
                  backgroundColor: WidgetStatePropertyAll(
                    colorScheme.surfaceContainer,
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: _onChanged,
                  onSubmitted: _onSubmitted,
                ),
              ),
            ),
            Expanded(child: _buildBody(query)),
          ],
        ),
      ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  final IconData icon;
  final String message;

  const _SearchMessage({required this.icon, required this.message});

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
            Icon(icon, size: 48, color: colorScheme.secondary),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _StoreSearchCard extends StatelessWidget {
  final StoreSearchResult store;
  final VoidCallback? onTap;

  const _StoreSearchCard({required this.store, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = store.description;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(store.avatarUrl, size: 64),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${store.address.street}, ${store.address.neighborhood}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    _RatingLabel(rating: store.rating),
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
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

class _RatingLabel extends StatelessWidget {
  final Rating rating;

  const _RatingLabel({required this.rating});

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
        const SizedBox(width: 2),
        Text(
          rating.average.toStringAsFixed(1),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(' (${rating.count})', style: theme.textTheme.bodySmall),
      ],
    );
  }
}
