import 'package:dio/dio.dart';
import 'package:go_to_save_app/core/http/api_runner.dart';

class UserRepository {
  final Dio _api;

  UserRepository(this._api);

  Future<void> updateAvatar(String avatarPath) {
    return runApiCall(() async {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(avatarPath),
      });

      await _api.put('/me/avatar', data: formData);
    });
  }

  Future<void> removeAvatar() {
    return runApiCall(() async {
      await _api.delete('/me/avatar');
    });
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
  }) {
    return runApiCall(() async {
      await _api.patch(
        '/me',
        data: {'firstName': firstName, 'lastName': lastName},
      );
    });
  }

  Future<void> updateEmail(String email) {
    return runApiCall(() async {
      await _api.patch('/me/email', data: {'email': email});
    });
  }

  Future<void> requestEmailVerification(String email) {
    return runApiCall(() async {
      await _api.post('/email-verification', data: {'email': email});
    });
  }

  Future<void> verifyEmail({required String email, required String code}) {
    return runApiCall(() async {
      await _api.patch('/verify-email', data: {'email': email, 'code': code});
    });
  }

  Future<void> updatePassword({
    required String password,
    required String newPassword,
  }) {
    return runApiCall(() async {
      await _api.patch(
        '/me/password',
        data: {'password': password, 'newPassword': newPassword},
      );
    });
  }
}
