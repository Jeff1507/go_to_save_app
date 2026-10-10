import 'package:flutter/material.dart';
import 'package:go_to_save_app/features/stores/models/store.dart';
import 'package:intl/intl.dart';

class BagCard extends StatelessWidget {
  final BagSummary bag;
  final VoidCallback? onTap;

  const BagCard({super.key, required this.bag, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final priceFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

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
                        priceFormat.format(bag.originalPriceInBRL),
                        style: theme.textTheme.bodySmall?.copyWith(
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
            ],
          ),
        ),
      ),
    );
  }
}
