import 'package:dio/dio.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';

Future<T> runApiCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    throw ApiException(e);
  }
}
