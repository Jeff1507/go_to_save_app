import 'package:go_to_save_app/core/auth/user.dart';

enum AuthStatus { authenticated, unauthenticated, error, unknown }

class AuthState {
  final AuthStatus status;
  final User? user;

  const AuthState._(this.status, this.user);

  const AuthState.authenticated(User user)
    : this._(AuthStatus.authenticated, user);

  const AuthState.unauthenticated() : this._(AuthStatus.unauthenticated, null);

  const AuthState.error() : this._(AuthStatus.error, null);

  const AuthState.unknown() : this._(AuthStatus.unknown, null);
}
