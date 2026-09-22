import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(DioException e)
    : message = _resolveMessage(e),
      statusCode = _resolveStatusCode(e);

  static String _resolveMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Tempo de conexão esgotado. Tente novamente mais tarde.';
    }

    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map && data['errors'] is Map) {
        return 'Todos os campos precisam ser válidos.';
      }

      if (data is Map && data['error'] is String) {
        return data['error'] as String;
      }

      return 'Erro interno no servidor.';
    }

    return 'Sem conexão com a internet.';
  }

  static int? _resolveStatusCode(DioException e) {
    if (e.response == null) return null;
    return e.response?.statusCode;
  }

  @override
  String toString() => message;
}
