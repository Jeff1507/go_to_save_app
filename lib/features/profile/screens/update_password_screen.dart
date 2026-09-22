import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/features/profile/providers/update_password_provider.dart';
import 'package:go_to_save_app/shared/widgets/error_alert.dart';
import 'package:go_to_save_app/shared/widgets/loading_button.dart';
import 'package:go_to_save_app/shared/widgets/password_form_field.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';

class UpdatePasswordScreen extends ConsumerStatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends ConsumerState<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
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

  String? _validateConfirmNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha obrigatória';
    }

    if (value != _newPasswordController.text) {
      return 'As senha devem coincidir';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(updatePasswordProvider.notifier)
        .updatePassword(
          password: _passwordController.text,
          newPassword: _newPasswordController.text,
        );

    if (!mounted) return;

    final state = ref.read(updatePasswordProvider);
    if (state.hasError) return;

    Toast.success(context, 'Senha atualizada com sucesso!');
  }

  @override
  Widget build(BuildContext context) {
    final update = ref.watch(updatePasswordProvider);
    final isLoading = update.isLoading;
    final error = update.error;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Alterar senha'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (error != null && error is ApiException)
                  ErrorAlert(error.message),

                PasswordFormField(
                  controller: _passwordController,
                  enabled: !isLoading,
                  validator: _validatePassword,
                  labelText: 'Senha atual',
                  border: OutlineInputBorder(),
                ),

                const SizedBox(height: 16),

                PasswordFormField(
                  controller: _newPasswordController,
                  enabled: !isLoading,
                  validator: _validatePassword,
                  labelText: 'Nova senha',
                  border: OutlineInputBorder(),
                ),

                const SizedBox(height: 16),

                PasswordFormField(
                  controller: _confirmNewPasswordController,
                  enabled: !isLoading,
                  validator: _validateConfirmNewPassword,
                  labelText: 'Confirmar nova senha',
                  border: OutlineInputBorder(),
                ),

                const SizedBox(height: 16),

                Text(
                  'Ao alterar a senha, você será desconectado de todos os dispositivos.',
                ),

                const SizedBox(height: 16),

                LoadingButton(
                  label: 'Alterar',
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
