import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/auth/providers/auth_repository_provider.dart';

class RequestPasswordResetNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> requestPasswordReset(String email) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.requestPasswordReset(email);
    });
  }
}

final requestPasswordResetProvider =
    AsyncNotifierProvider.autoDispose<RequestPasswordResetNotifier, void>(
      RequestPasswordResetNotifier.new,
    );
