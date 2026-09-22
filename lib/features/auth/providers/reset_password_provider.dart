// lib/features/auth/providers/reset_password_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/auth/repositories/auth_repository_provider.dart';

class ResetPasswordNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
    });
  }
}

final resetPasswordProvider =
    AsyncNotifierProvider.autoDispose<ResetPasswordNotifier, void>(
      ResetPasswordNotifier.new,
    );
