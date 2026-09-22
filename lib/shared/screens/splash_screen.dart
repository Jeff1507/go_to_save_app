import 'package:flutter/material.dart';
import 'package:go_to_save_app/shared/widgets/logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Logo(
          size: LogoSize.lg,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
