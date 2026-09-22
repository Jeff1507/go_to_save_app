import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/auth/providers/resend_cooldown_notifier.dart';
import 'package:go_to_save_app/features/auth/repositories/auth_repository_provider.dart';

class ResendEmailVerificationNotifier extends ResendCooldownNotifier {
  late String _email;

  void setEmail(String email) => _email = email;

  @override
  Future<void> performRequest() {
    final repo = ref.read(authRepositoryProvider);
    return repo.requestEmailVerification(_email);
  }
}

final resendEmailVerificationProvider =
    NotifierProvider.autoDispose<
      ResendEmailVerificationNotifier,
      ResendCooldownState
    >(ResendEmailVerificationNotifier.new);
