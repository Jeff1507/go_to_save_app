import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/features/auth/providers/auth_repository_provider.dart';

class LogoutAllNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> logoutAll() async {
    state = AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.logoutAll();

      ref.read(authStateProvider.notifier).refresh();
    });
  }
}

final logoutAllProvider =
    AsyncNotifierProvider.autoDispose<LogoutAllNotifier, void>(
      LogoutAllNotifier.new,
    );
