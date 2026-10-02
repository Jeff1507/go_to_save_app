import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/http/api_exception.dart';
import 'package:go_to_save_app/features/auth/providers/logout_all_provider.dart';
import 'package:go_to_save_app/features/auth/providers/logout_provider.dart';
import 'package:go_to_save_app/features/profile/providers/remove_avatar_provider.dart';
import 'package:go_to_save_app/features/profile/providers/require_current_user_provider.dart';
import 'package:go_to_save_app/features/profile/providers/upload_avatar_provider.dart';
import 'package:go_to_save_app/features/profile/widgets/avatar_options_sheet.dart';
import 'package:go_to_save_app/features/profile/widgets/settings_menu_group.dart';
import 'package:go_to_save_app/shared/widgets/confirmation_dialog.dart';
import 'package:go_to_save_app/shared/widgets/toast.dart';
import 'package:go_to_save_app/shared/widgets/user_avatar.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Encerrar sessão?',
      description: 'Você será desconectado e voltará para tela de login.',
      isDestructive: true,
    );
    if (!confirmed) return;

    await ref.read(logoutProvider.notifier).logout();
  }

  Future<void> _logoutAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Encerrar todas as sessões?',
      description: 'Você será desconectado de todos os dispositivos e voltará para tela de login.',
      isDestructive: true,
    );
    if (!confirmed) return;

    await ref.read(logoutAllProvider.notifier).logoutAll();
  }

  Future<void> _showAvatarOptions(
    BuildContext context,
    WidgetRef ref,
    String? avatarUrl,
  ) async {
    final action = await showModalBottomSheet<AvatarAction>(
      context: context,
      useSafeArea: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AvatarOptionsSheet(hasAvatar: avatarUrl != null),
    );

    if (action == null || !context.mounted) return;

    switch (action) {
      case AvatarAction.camera:
        await _pickupAndUpload(ref, ImageSource.camera);
      case AvatarAction.gallery:
        await _pickupAndUpload(ref, ImageSource.gallery);
      case AvatarAction.remove:
        await _removeAvatar(context, ref);
    }
  }

  Future<void> _pickupAndUpload(WidgetRef ref, ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, maxWidth: 1024);

    if (image == null) return;

    await ref
        .read(uploadAvatarProvider.notifier)
        .uploadAvatar(avatarPath: image.path);
  }

  Future<void> _removeAvatar(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Remover foto de perfil?',
      description:
          'Sua foto atual será removida. Você pode adicionar uma nova depois.',
      confirmLabel: 'Remover',
      isDestructive: true,
    );
    if (!confirmed) return;

    await ref.read(removeAvatarProvider.notifier).removeAvatar();
  }

  void _showError(BuildContext context, AsyncValue<void> value) {
    final error = value.error;
    if (error == null) return;

    final message = error is ApiException
        ? error.message
        : 'Algo deu errado. Tente novamente.';

    Toast.error(context, message);
  }

  void _listenAndShowErrors(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(logoutProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasError) {
        _showError(context, next);
      }
    });

    ref.listen<AsyncValue<void>>(logoutAllProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasError) {
        _showError(context, next);
      }
    });

    ref.listen<AsyncValue<void>>(uploadAvatarProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasError) {
        _showError(context, next);
      }
    });

    ref.listen<AsyncValue<void>>(removeAvatarProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasError) {
        _showError(context, next);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(requireCurrentUserProvider);
    final isUploading = ref.watch(uploadAvatarProvider).isLoading;
    final isRemoving = ref.watch(removeAvatarProvider).isLoading;
    final isAvatarBusy = isUploading || isRemoving;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    _listenAndShowErrors(context, ref);

    return Scaffold(
      appBar: AppBar(title: Text('Perfil'), centerTitle: true),
      body: Stack(
        children: [
          if (isAvatarBusy) LinearProgressIndicator(),

          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!user.isVerified)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_rounded, color: Colors.orange),
                              const SizedBox(width: 12),
                              Text('Verifique seu email'),
                            ],
                          ),

                          TextButton(
                            child: Text('Verificar'),
                            onPressed: () => context.push('/verify-email'),
                          ),
                        ],
                      ),
                    ),

                  Stack(
                    children: [
                      UserAvatar(user.avatarUrl),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: IconButton.filledTonal(
                          onPressed: () =>
                              _showAvatarOptions(context, ref, user.avatarUrl),
                          icon: Icon(Icons.camera_alt_outlined),
                          style: IconButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainer,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    user.fullName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    user.email,
                    style: TextStyle(color: colorScheme.inverseSurface),
                  ),

                  const SizedBox(height: 32),

                  SettingsMenuGroup(
                    items: [
                      SettingsMenuItem(
                        icon: Icons.edit_outlined,
                        title: 'Editar perfil',
                        onTap: () => context.push('/update-profile'),
                      ),
                      SettingsMenuItem(
                        icon: Icons.mail_outlined,
                        title: 'Alterar email',
                        onTap: () => context.push('/update-email'),
                      ),
                      SettingsMenuItem(
                        icon: Icons.password_outlined,
                        title: 'Alterar senha',
                        onTap: () => context.push('/update-password'),
                      ),
                      SettingsMenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Localização',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SettingsMenuGroup(
                    items: [
                      SettingsMenuItem(
                        icon: Icons.logout_outlined,
                        title: 'Encerrar sessão',
                        onTap: () => _logout(context, ref),
                      ),
                      SettingsMenuItem(
                        icon: Icons.exit_to_app_outlined,
                        title: 'Encerrar todas as sessões',
                        onTap: () => _logoutAll(context, ref),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SettingsMenuGroup(
                    items: [
                      SettingsMenuItem(
                        icon: Icons.person_off_outlined,
                        title: 'Excluir a conta',
                        onTap: () {},
                        color: colorScheme.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
