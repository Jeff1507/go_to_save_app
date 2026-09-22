import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/features/profile/providers/user_repository_provider.dart';

class UpdateProfileNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(userRepositoryProvider);
      await repo.updateProfile(firstName: firstName, lastName: lastName);

      ref.read(authStateProvider.notifier).refresh();
    });
  }
}

final updateProfileProvider =
    AsyncNotifierProvider.autoDispose<UpdateProfileNotifier, void>(
      UpdateProfileNotifier.new,
    );
