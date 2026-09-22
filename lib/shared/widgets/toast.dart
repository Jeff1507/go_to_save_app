import 'package:flutter/material.dart';

enum ToastType { success, error, info, warning }

class _SnackBarConfig {
  final IconData icon;
  final Color color;

  _SnackBarConfig({required this.icon, required this.color});
}

abstract final class Toast {
  const Toast();

  static _SnackBarConfig _configFor(ToastType type, ColorScheme colorScheme) {
    switch (type) {
      case ToastType.success:
        return _SnackBarConfig(
          icon: Icons.check_circle_rounded,
          color: Colors.greenAccent,
        );
      case ToastType.error:
        return _SnackBarConfig(icon: Icons.error, color: Colors.redAccent);
      case ToastType.warning:
        return _SnackBarConfig(icon: Icons.warning, color: Colors.orangeAccent);
      case ToastType.info:
        return _SnackBarConfig(icon: Icons.info, color: Colors.blueAccent);
    }
  }

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final config = _configFor(type, colorScheme);

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(config.icon, color: config.color),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: colorScheme.inverseSurface,

          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
          action: action,
        ),
      );
  }

  static void success(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    show(context, message: message, type: ToastType.success, action: action);
  }

  static void error(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    show(context, message: message, type: ToastType.error, action: action);
  }

  static void info(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    show(context, message: message, type: ToastType.info, action: action);
  }

  static void warning(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    show(context, message: message, type: ToastType.warning, action: action);
  }
}
