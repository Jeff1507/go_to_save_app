import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/http/api_client.dart';
import 'package:go_to_save_app/core/http/api_interceptors.dart';
import 'package:go_to_save_app/core/storage/session_storage_provider.dart';

final apiProvider = Provider<Dio>((ref) {
  final api = ApiClient.create();
  final sessionStorage = ref.read(sessionStorageProvider);

  api.interceptors.add(AuthInterceptor(sessionStorage, ref));

  return api;
});
