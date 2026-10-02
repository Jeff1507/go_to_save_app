import 'package:dio/dio.dart';
import 'package:go_to_save_app/core/http/api_runner.dart';
import 'package:go_to_save_app/core/storage/session_storage.dart';
import 'package:go_to_save_app/features/auth/models/session.dart';

class AuthRepository {
  final Dio _api;
  final SessionStorage _sessionStorage;

  AuthRepository(this._api, this._sessionStorage);

  Future<Session> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return runApiCall(() async {
      final response = await _api.post(
        '/signup',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
      );

      final session = Session.fromJson(response.data);
      await _sessionStorage.save(session.id);

      return session;
    });
  }

  Future<Session> login({required String email, required String password}) {
    return runApiCall(() async {
      final response = await _api.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final session = Session.fromJson(response.data);
      await _sessionStorage.save(session.id);

      return session;
    });
  }

  Future<void> logout() {
    return runApiCall(() async {
      await _api.post('/logout');
    });
  }

  Future<void> logoutAll() {
    return runApiCall(() async {
      await _api.post('/logout-all');
    });
  }

  Future<void> requestPasswordReset(String email) {
    return runApiCall(() async {
      await _api.post('/password-reset', data: {'email': email});
    });
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return runApiCall(() async {
      await _api.patch(
        '/reset-password',
        data: {'email': email, 'code': code, 'newPassword': newPassword},
      );
    });
  }
}
