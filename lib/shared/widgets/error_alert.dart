import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  final String message;

  const ErrorAlert(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      color: colorScheme.surfaceContainer,
      child: Row(
        children: [
          Icon(Icons.error, color: colorScheme.error),
          const SizedBox(width: 12),
          Text(message, style: TextStyle(color: colorScheme.error)),
        ],
      ),
    );
  }
}
