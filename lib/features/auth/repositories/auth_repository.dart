import 'package:dio/dio.dart';
import 'package:go_to_save_app/core/http/api_runner.dart';
import 'package:go_to_save_app/core/storage/session_storage.dart';
import 'package:go_to_save_app/features/auth/models/session_model.dart';

class AuthRepository {
  final Dio _api;
  final SessionStorage _sessionStorage;

  AuthRepository(this._api, this._sessionStorage);

  Future<SessionModel> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return runApiCall(() async {
      final response = await _api.post(
        '/customers/signup',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
      );

      final session = SessionModel.fromJson(response.data);
      await _sessionStorage.save(session.id);

      return session;
    });
  }

  Future<SessionModel> login({
    required String email,
    required String password,
  }) {
    return runApiCall(() async {
      final response = await _api.post(
        '/customers/login',
        data: {'email': email, 'password': password},
      );

      final session = SessionModel.fromJson(response.data);
      await _sessionStorage.save(session.id);

      return session;
    });
  }

  Future<void> logout() {
    return runApiCall(() async {
      await _api.post('/customers/logout');
    });
  }

  Future<void> logoutAll() {
    return runApiCall(() async {
      await _api.post('/customers/logout-all');
    });
  }

  Future<void> requestEmailVerification(String email) {
    return runApiCall(() async {
      await _api.post('/customers/email-verification', data: {'email': email});
    });
  }

  Future<void> verifyEmail({required String email, required String code}) {
    return runApiCall(() async {
      await _api.patch(
        '/customers/verify-email',
        data: {'email': email, 'code': code},
      );
    });
  }

  Future<void> requestPasswordReset(String email) {
    return runApiCall(() async {
      await _api.post('/customers/password-reset', data: {'email': email});
    });
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return runApiCall(() async {
      await _api.patch(
        '/customers/reset-password',
        data: {'email': email, 'code': code, 'newPassword': newPassword},
      );
    });
  }
}
