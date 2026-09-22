import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/features/auth/repositories/auth_repository_provider.dart';

class SignupNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signup(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

      ref.read(authStateProvider.notifier).refresh();
    });
  }
}

final signupProvider = AsyncNotifierProvider.autoDispose<SignupNotifier, void>(
  SignupNotifier.new,
);
