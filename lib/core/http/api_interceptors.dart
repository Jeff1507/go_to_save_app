import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/core/storage/session_storage.dart';

class UnwrapDataInterceptor extends Interceptor {
  const UnwrapDataInterceptor();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map && response.data['data'] != null) {
      response.data = response.data['data'];
    }

    handler.next(response);
  }
}

class AuthInterceptor extends Interceptor {
  final SessionStorage _sessionStorage;
  final Ref _ref;

  AuthInterceptor(this._sessionStorage, this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final sessionId = await _sessionStorage.get();
    if (sessionId != null) {
      options.headers['Authorization'] = 'Bearer $sessionId';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _ref.read(authStateProvider.notifier).logout();
    }

    handler.next(err);
  }
}
