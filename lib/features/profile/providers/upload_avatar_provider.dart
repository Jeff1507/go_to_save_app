import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/features/profile/providers/user_repository_provider.dart';

class UploadAvatarNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> uploadAvatar({required String avatarPath}) async {
    state = const AsyncLoading<void>();

    final result = await AsyncValue.guard(() async {
      final repo = ref.read(userRepositoryProvider);
      await repo.updateAvatar(avatarPath);

      ref.read(authStateProvider.notifier).refresh();
    });

    if (ref.mounted) {
      state = result;
    }
  }
}

final uploadAvatarProvider =
    AsyncNotifierProvider.autoDispose<UploadAvatarNotifier, void>(
      UploadAvatarNotifier.new,
    );
