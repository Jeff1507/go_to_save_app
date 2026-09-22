import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/features/profile/providers/user_repository_provider.dart';

class UpdateEmailNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> updateEmail(String email) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(userRepositoryProvider);
      await repo.updateEmail(email);

      ref.read(authStateProvider.notifier).refresh();
    });
  }
}

final updateEmailProvider =
    AsyncNotifierProvider.autoDispose<UpdateEmailNotifier, void>(
      UpdateEmailNotifier.new,
    );
