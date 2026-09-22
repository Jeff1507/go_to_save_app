import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';

class ResendCooldownState {
  final int secondsRemaining;
  final bool isLoading;
  final ApiException? error;

  const ResendCooldownState({
    this.secondsRemaining = 0,
    this.isLoading = false,
    this.error,
  });

  bool get canResend => secondsRemaining == 0 && !isLoading;

  ResendCooldownState copyWith({
    int? secondsRemaining,
    bool? isLoading,
    ApiException? error,
    bool clearError = false,
  }) {
    return ResendCooldownState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

abstract class ResendCooldownNotifier extends Notifier<ResendCooldownState> {
  Timer? _timer;
  static const cooldownSeconds = 30;

  @override
  ResendCooldownState build() {
    ref.onDispose(() => _timer?.cancel());
    return const ResendCooldownState();
  }

  Future<void> performRequest();

  Future<void> resend() async {
    if (!state.canResend) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await performRequest();
      state = state.copyWith(isLoading: false);
      _startCooldown();
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  void _startCooldown() {
    state = state.copyWith(secondsRemaining: cooldownSeconds);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.secondsRemaining - 1;
      if (remaining <= 0) {
        timer.cancel();
        state = state.copyWith(secondsRemaining: 0);
      } else {
        state = state.copyWith(secondsRemaining: remaining);
      }
    });
  }
}
