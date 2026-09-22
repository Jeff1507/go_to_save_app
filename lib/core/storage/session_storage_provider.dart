import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/storage/session_storage.dart';

final sessionStorageProvider = Provider<SessionStorage>(
  (ref) => SessionStorage(),
);
