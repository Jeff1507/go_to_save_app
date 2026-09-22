import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/features/auth/providers/signup_provider.dart';
import 'package:go_to_save_app/shared/validators/email_validator.dart';
import 'package:go_to_save_app/shared/widgets/error_alert.dart';
import 'package:go_to_save_app/shared/widgets/loading_button.dart';
import 'package:go_to_save_app/shared/widgets/logo.dart';
import 'package:go_to_save_app/shared/widgets/password_form_field.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome obrigatório';
    }

    if (value.length < 3) {
      return 'Nome muito curto';
    }

    if (value.length > 50) {
      return 'Nome muito longo';
    }

    return null;
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
        .read(signupProvider.notifier)
        .signup(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    final state = ref.read(signupProvider);
    if (state.hasError) return;

    Toast.success(context, 'Conta criada com sucesso!');
  }

  @override
  Widget build(BuildContext context) {
    final signup = ref.watch(signupProvider);
    final isLoading = signup.isLoading;
    final error = signup.error;
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
                    Icons.face_outlined,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Crie uma conta',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Faça parte da nossa comunidade contra o desperdício.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.inverseSurface),
                ),

                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        enabled: !isLoading,
                        validator: _validateName,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        enabled: !isLoading,
                        validator: _validateName,
                        decoration: const InputDecoration(
                          labelText: 'Sobrenome',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

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

                LoadingButton(
                  label: 'Criar',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já possui uma conta?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Faça login',
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
