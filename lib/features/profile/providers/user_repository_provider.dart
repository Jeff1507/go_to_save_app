import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/http/api_provider.dart';
import 'package:go_to_save_app/features/profile/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(ref.watch(apiProvider)),
);
