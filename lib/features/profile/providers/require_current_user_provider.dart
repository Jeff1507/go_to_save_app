import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/core/auth/user.dart';

class UnauthenticatedError extends Error {
  @override
  String toString() => 'Warn: Usuário sem autorização.';
}

/// Expõe o [User] atualmente autenticado, para uso em telas que só
/// deveriam ser acessíveis a usuários logados.
///
/// Lança [UnauthenticatedError] se não houver usuário autenticado no
/// momento da leitura.
///
/// ⚠️ **Erro transitório esperado durante logout**: ao chamar
/// `logout()`/`logoutAll()`, o [authStateProvider] passa por
/// `unauthenticated` *antes* do [GoRouter] reagir e desmontar a tela
/// protegida. Nesse intervalo, qualquer widget ainda montado que
/// observe este provider vai relançar [UnauthenticatedError], visível
/// no console como uma exceção capturada pelo Riverpod
/// ("EXCEPTION CAUGHT BY RIVERPOD"). Isso é esperado e não afeta o
/// usuário — a tela é substituída pelo redirect do router logo em
/// seguida. Não é necessário tratar esse erro aqui; ele não deve
/// aparecer em produção com telemetria de erro configurada para
/// ignorá-lo, caso seja necessário.
///
/// Só deve ser lido em telas dentro do fluxo autenticado (protegidas
/// pelo `redirect` do router). Um erro fora desse contexto é sinal de
/// bug de uso, não de fluxo normal.
final requireCurrentUserProvider = Provider<User>((ref) {
  final user = ref.watch(authStateProvider).user;
  if (user == null) {
    throw UnauthenticatedError();
  }

  return user;
});
