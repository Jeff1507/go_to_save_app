import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_status.dart';
import 'package:go_to_save_app/core/auth/user.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/core/http/api_provider.dart';
import 'package:go_to_save_app/core/http/api_runner.dart';
import 'package:go_to_save_app/core/storage/session_storage_provider.dart';

class AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkCurrentUser();
    return const AuthState.unknown();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final sessionId = await ref.read(sessionStorageProvider).get();
      if (sessionId == null) {
        state = const AuthState.unauthenticated();
        return;
      }

      final user = await _getCurrentUser();
      state = AuthState.authenticated(user);
    } on ApiException catch (e) {
      if (e.statusCode != 401) {
        state = const AuthState.error();
      }
    }
  }

  Future<User> _getCurrentUser() {
    final api = ref.read(apiProvider);
    return runApiCall(() async {
      final response = await api.get('/customers/me');
      return User.fromJson(response.data);
    });
  }

  Future<void> refresh() => _checkCurrentUser();

  Future<void> logout() async {
    await ref.read(sessionStorageProvider).delete();
    state = const AuthState.unauthenticated();
  }
}

final authStateProvider = NotifierProvider<AuthStateNotifier, AuthState>(
  AuthStateNotifier.new,
);
