import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/http/api_provider.dart';
import 'package:go_to_save_app/core/storage/session_storage_provider.dart';
import 'package:go_to_save_app/features/auth/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) =>
      AuthRepository(ref.watch(apiProvider), ref.watch(sessionStorageProvider)),
);
