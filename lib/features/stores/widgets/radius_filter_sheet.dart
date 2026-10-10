import 'package:flutter/material.dart';

class RadiusFilterSheet extends StatefulWidget {
  final int selectedRadius;

  const RadiusFilterSheet({super.key, required this.selectedRadius});

  @override
  State<RadiusFilterSheet> createState() => _RadiusFilterSheetState();
}

class _RadiusFilterSheetState extends State<RadiusFilterSheet> {
  late double _radius = widget.selectedRadius.toDouble();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 24, left: 24, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),

          Container(
            width: 56,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Lojas em até ${(_radius / 1000).toStringAsFixed(1)} km',
            style: theme.textTheme.titleSmall,
          ),
          Slider(
            value: _radius,
            min: 500,
            max: 15000,
            divisions: 29, // passos de 500m
            onChanged: (value) => setState(() => _radius = value),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, _radius.round()),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }
}
