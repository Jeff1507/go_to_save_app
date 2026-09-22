import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/features/profile/providers/update_email_provider.dart';
import 'package:go_to_save_app/shared/validators/email_validator.dart';
import 'package:go_to_save_app/shared/widgets/error_alert.dart';
import 'package:go_to_save_app/shared/widgets/loading_button.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';

class UpdateEmailScreen extends ConsumerStatefulWidget {
  const UpdateEmailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends ConsumerState<UpdateEmailScreen> {
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

    await ref
        .read(updateEmailProvider.notifier)
        .updateEmail(_emailController.text);

    if (!mounted) return;

    final state = ref.read(updateEmailProvider);
    if (state.hasError) return;

    Toast.success(context, 'Email atualizado com sucesso!');
    context.push('/verify-email');
  }

  @override
  Widget build(BuildContext context) {
    final update = ref.watch(updateEmailProvider);
    final isLoading = update.isLoading;
    final error = update.error;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Alterar email'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (error != null && error is ApiException)
                  ErrorAlert(error.message),

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

                Text(
                  'Ao alterar seu e-mail, você precisará verificar o novo endereço.',
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
