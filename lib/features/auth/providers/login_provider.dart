import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/features/auth/providers/auth_repository_provider.dart';

class LoginNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.login(email: email, password: password);

      ref.read(authStateProvider.notifier).refresh();
    });
  }
}

final loginProvider = AsyncNotifierProvider.autoDispose<LoginNotifier, void>(
  LoginNotifier.new,
);
