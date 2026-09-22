import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_to_save_app/core/auth/auth_status.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref, ProviderListenable<AuthState> provider) {
    ref.listen<AuthState>(provider, (_, _) => notifyListeners());
  }
}
