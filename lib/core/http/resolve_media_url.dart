import 'package:go_to_save_app/shared/env/env.dart';

String? resolveMediaUrl(String? mediaUrl) {
  if (mediaUrl == null) return null;

  return '$apiBaseUrl$mediaUrl';
}
