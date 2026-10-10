import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/router/router_provider.dart';
import 'package:go_to_save_app/core/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

// TODO: Organizar melhor os arquivos
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Go to Save',
      theme: appTheme(),
      routerConfig: router,
    );
  }
}
