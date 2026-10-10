import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/shared/widgets/error_state_view.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: ErrorStateView(
          icon: Icons.wifi_off_outlined,
          message: 'Sem conexão com a internet.',
          actionLabel: 'Tentar novamente',
          onAction: () => context.go('/home'),
        ),
      ),
    );
  }
}
