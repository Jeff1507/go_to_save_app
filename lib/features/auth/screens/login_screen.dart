import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/features/auth/providers/login_provider.dart';
import 'package:go_to_save_app/shared/validators/email_validator.dart';
import 'package:go_to_save_app/shared/widgets/error_alert.dart';
import 'package:go_to_save_app/shared/widgets/loading_button.dart';
import 'package:go_to_save_app/shared/widgets/logo.dart';
import 'package:go_to_save_app/shared/widgets/password_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha obrigatória';
    }

    if (value.length < 8) {
      return 'Senha muito curta';
    }

    if (value.length > 72) {
      return 'Senha muito longa';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(loginProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginProvider);
    final isLoading = login.isLoading;
    final error = login.error;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Logo(), centerTitle: true),
        body: SingleChildScrollView(
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
                    Icons.lock_person_outlined,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Entre com sua conta',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),

                const SizedBox(height: 4),

                Text(
                  'Insira suas credenciais para continuar',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.inverseSurface),
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: _emailController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                PasswordFormField(
                  controller: _passwordController,
                  enabled: !isLoading,
                  validator: _validatePassword,
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => context.push('/forgot-password'),
                    child: Text(
                      'Esqueci minha senha',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                LoadingButton(
                  label: 'Entrar',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não possui uma conta?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
