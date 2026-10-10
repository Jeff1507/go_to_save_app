import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/http/api_provider.dart';
import 'package:go_to_save_app/features/stores/repositories/store_repository.dart';

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository(ref.read(apiProvider));
});
