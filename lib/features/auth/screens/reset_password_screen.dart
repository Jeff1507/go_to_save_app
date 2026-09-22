import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/features/auth/providers/resend_password_reset_provider.dart';
import 'package:go_to_save_app/features/auth/providers/reset_password_provider.dart';
import 'package:go_to_save_app/shared/widgets/error_alert.dart';
import 'package:go_to_save_app/shared/widgets/loading_button.dart';
import 'package:go_to_save_app/shared/widgets/otp_input.dart';
import 'package:go_to_save_app/shared/widgets/password_form_field.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _otpError;

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateOtp(String otp) {
    if (otp.trim().isEmpty) {
      return 'Código obrigatório';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      return 'O código deve conter apenas dígitos';
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

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'As senha devem coincidir';
    }

    return null;
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState!.validate();
    final otpErrorMsg = _validateOtp(_otpController.text);
    final otpHasError = otpErrorMsg != null;

    setState(() {
      _otpError = otpHasError ? otpErrorMsg : null;
    });

    if (!formValid || otpHasError) return;

    await ref
        .read(resetPasswordProvider.notifier)
        .resetPassword(
          email: widget.email,
          code: _otpController.text,
          newPassword: _passwordController.text,
        );

    if (!mounted) return;

    final state = ref.read(resetPasswordProvider);
    if (state.hasError) {
      _otpController.clear();
      return;
    }

    Toast.success(context, 'Senha redefinida com sucesso!');
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    final reset = ref.watch(resetPasswordProvider);
    final isLoading = reset.isLoading;
    final error = reset.error;
    final resend = ref.watch(resendPasswordResetProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ref.read(resendPasswordResetProvider.notifier).setEmail(email);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Redefinir senha'), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (error != null && error is ApiException)
                  ErrorAlert(error.message),

                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Digite o código enviado para '),
                      TextSpan(
                        text: email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: '\ne crie sua nova senha.'),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Column(
                  children: [
                    OtpInput(
                      controller: _otpController,
                      focusNode: _otpFocusNode,
                      enabled: !isLoading,
                      onCompleted: (_) {},
                    ),

                    if (_otpError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _otpError!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: resend.canResend
                          ? () => ref
                                .read(resendPasswordResetProvider.notifier)
                                .resend()
                          : null,
                      child: resend.isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.primary,
                              ),
                            )
                          : Text(
                              resend.secondsRemaining > 0
                                  ? 'Reenviar código (${resend.secondsRemaining} s)'
                                  : 'Reenviar código',
                            ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Divider(),
                ),

                PasswordFormField(
                  controller: _passwordController,
                  enabled: !isLoading,
                  validator: _validatePassword,
                  labelText: 'Nova senha',
                  border: OutlineInputBorder(),
                ),

                const SizedBox(height: 16),

                PasswordFormField(
                  controller: _confirmPasswordController,
                  enabled: !isLoading,
                  validator: _validateConfirmPassword,
                  labelText: 'Confirmar nova senha',
                  border: OutlineInputBorder(),
                ),

                const SizedBox(height: 16),

                LoadingButton(
                  label: 'Redefinir senha',
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
