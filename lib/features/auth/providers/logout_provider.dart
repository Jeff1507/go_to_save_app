import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/features/auth/repositories/auth_repository_provider.dart';

class LogoutNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> logout() async {
    state = AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.logout();

      ref.read(authStateProvider.notifier).refresh();
    });
  }
}

final logoutProvider = AsyncNotifierProvider.autoDispose<LogoutNotifier, void>(
  LogoutNotifier.new,
);
