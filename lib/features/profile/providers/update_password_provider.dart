import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/features/profile/providers/user_repository_provider.dart';

class UpdatePasswordNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> updatePassword({
    required String password,
    required String newPassword,
  }) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(userRepositoryProvider);
      await repo.updatePassword(password: password, newPassword: newPassword);

      ref.read(authStateProvider.notifier).refresh();
    });
  }
}

final updatePasswordProvider =
    AsyncNotifierProvider.autoDispose<UpdatePasswordNotifier, void>(
      UpdatePasswordNotifier.new,
    );
