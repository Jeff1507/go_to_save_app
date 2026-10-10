import 'package:flutter/material.dart';

class EnableLocationPrompt extends StatelessWidget {
  final VoidCallback onPressed;

  const EnableLocationPrompt({super.key, required this.onPressed});

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
