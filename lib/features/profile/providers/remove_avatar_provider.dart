import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/features/profile/providers/user_repository_provider.dart';

class RemoveAvatarNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> removeAvatar() async {
    state = const AsyncLoading<void>();

    final result = await AsyncValue.guard(() async {
      final repo = ref.read(userRepositoryProvider);
      await repo.removeAvatar();

      ref.read(authStateProvider.notifier).refresh();
    });

    if (ref.mounted) {
      state = result;
    }
  }
}

final removeAvatarProvider =
    AsyncNotifierProvider.autoDispose<RemoveAvatarNotifier, void>(
      RemoveAvatarNotifier.new,
    );
