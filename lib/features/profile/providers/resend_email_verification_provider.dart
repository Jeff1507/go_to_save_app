import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/shared/providers/resend_cooldown_notifier.dart';
import 'package:go_to_save_app/features/profile/providers/user_repository_provider.dart';

class ResendEmailVerificationNotifier extends ResendCooldownNotifier {
  late String _email;

  void setEmail(String email) => _email = email;

  @override
  Future<void> performRequest() {
    final repo = ref.read(userRepositoryProvider);
    return repo.requestEmailVerification(_email);
  }
}

final resendEmailVerificationProvider =
    NotifierProvider.autoDispose<
      ResendEmailVerificationNotifier,
      ResendCooldownState
    >(ResendEmailVerificationNotifier.new);
