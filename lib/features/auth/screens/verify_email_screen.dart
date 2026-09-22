import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/features/auth/providers/resend_email_verification_provider.dart';
import 'package:go_to_save_app/features/auth/providers/verify_email_provider.dart';
import 'package:go_to_save_app/features/profile/providers/require_current_user_provider.dart';
import 'package:go_to_save_app/shared/widgets/error_alert.dart';
import 'package:go_to_save_app/shared/widgets/otp_input.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String? _validateOtp(String? otp) {
    if (otp == null || otp.trim().isEmpty) {
      return 'Código obrigatório';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      return 'O código deve conter apenas dígitos';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = ref.read(requireCurrentUserProvider).email;
    await ref
        .read(verifyEmailProvider.notifier)
        .verifyEmail(email: email, code: _otpController.text);

    if (!mounted) return;

    final state = ref.read(verifyEmailProvider);
    if (state.hasError) {
      _otpController.clear();
      return;
    }

    Toast.success(context, 'Email verificado com sucesso!');
    context.go('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(requireCurrentUserProvider).email;
    final verify = ref.watch(verifyEmailProvider);
    final isLoading = verify.isLoading;
    final error = verify.error;
    final resend = ref.watch(resendEmailVerificationProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ref.read(resendEmailVerificationProvider.notifier).setEmail(email);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Verificar email'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (error != null && error is ApiException)
                  ErrorAlert(error.message),

                Center(
                  child: Icon(
                    Icons.mail_outline,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Verifique seu email',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Enviamos um código para '),
                      TextSpan(
                        text: email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                OtpInput(
                  controller: _otpController,
                  focusNode: _focusNode,
                  validator: _validateOtp,
                  enabled: !isLoading,
                  onCompleted: (_) => _submit(),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: resend.canResend
                      ? () => ref
                            .read(resendEmailVerificationProvider.notifier)
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
          ),
        ),
      ),
    );
  }
}
