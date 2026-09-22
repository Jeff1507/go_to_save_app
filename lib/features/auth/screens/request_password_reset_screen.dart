import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/features/auth/providers/request_password_reset_provider.dart';
import 'package:go_to_save_app/shared/validators/email_validator.dart';
import 'package:go_to_save_app/shared/widgets/error_alert.dart';
import 'package:go_to_save_app/shared/widgets/loading_button.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';

class RequestPasswordResetScreen extends ConsumerStatefulWidget {
  const RequestPasswordResetScreen({super.key});

  @override
  ConsumerState<RequestPasswordResetScreen> createState() =>
      _RequestPasswordResetScreenState();
}

class _RequestPasswordResetScreenState
    extends ConsumerState<RequestPasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email obrigatório';
    }

    if (!isValidEmail(value.trim())) {
      return 'Email inválido';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    await ref
        .read(requestPasswordResetProvider.notifier)
        .requestPasswordReset(email);

    if (!mounted) return;

    final state = ref.read(requestPasswordResetProvider);
    if (state.hasError) return;

    Toast.success(context, 'Código enviado com sucesso!');
    context.push('/reset-password', extra: email);
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(requestPasswordResetProvider);
    final isLoading = request.isLoading;
    final error = request.error;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Esqueci minha senha'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (error != null && error is ApiException)
                  ErrorAlert(error.message),

                Center(
                  child: Icon(
                    Icons.lock_reset_outlined,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Redefina sua senha',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(),
                ),

                const SizedBox(height: 4),

                Text(
                  'Informe seu email e enviaremos um código para redefinir sua senha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.inverseSurface),
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: _emailController,
                  enabled: !isLoading,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                LoadingButton(
                  label: 'Enviar código',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
