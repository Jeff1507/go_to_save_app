import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/features/profile/providers/require_current_user_provider.dart';
import 'package:go_to_save_app/features/profile/providers/update_profile_provider.dart';
import 'package:go_to_save_app/shared/widgets/error_alert.dart';
import 'package:go_to_save_app/shared/widgets/loading_button.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(requireCurrentUserProvider);
    _firstNameController = TextEditingController(text: user.firstName);
    _lastNameController = TextEditingController(text: user.lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(updateProfileProvider.notifier)
        .updateProfile(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        );

    if (!mounted) return;

    final state = ref.read(updateProfileProvider);
    if (state.hasError) return;

    Toast.success(context, 'Perfil atualizado com sucesso!');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final update = ref.watch(updateProfileProvider);
    final isLoading = update.isLoading;
    final error = update.error;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Editar perfil'), centerTitle: true),
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
                  controller: _firstNameController,
                  enabled: !isLoading,
                  validator: _validateName,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _lastNameController,
                  enabled: !isLoading,
                  validator: _validateName,
                  decoration: const InputDecoration(
                    labelText: 'Sobrenome',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                LoadingButton(
                  label: 'Salvar',
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
