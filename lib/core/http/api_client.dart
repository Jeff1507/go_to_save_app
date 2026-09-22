import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_to_save_app/core/http/api_interceptors.dart';
import 'package:go_to_save_app/shared/env/env.dart';

class ApiClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      UnwrapDataInterceptor(),

      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return dio;
  }
}
