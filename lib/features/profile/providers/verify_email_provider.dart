import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/features/profile/providers/user_repository_provider.dart';

class VerifyEmailNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(userRepositoryProvider);
      await repo.verifyEmail(email: email, code: code);
    });

    ref.read(authStateProvider.notifier).refresh();
  }
}

final verifyEmailProvider =
    AsyncNotifierProvider.autoDispose<VerifyEmailNotifier, void>(
      VerifyEmailNotifier.new,
    );
