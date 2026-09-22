import 'package:flutter/material.dart';

enum AvatarAction { camera, gallery, remove }

class AvatarOptionsSheet extends StatelessWidget {
  final bool hasAvatar;

  const AvatarOptionsSheet({super.key, required this.hasAvatar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),

        Container(
          width: 56,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        ListTile(
          leading: Icon(Icons.camera_outlined),
          title: Text('Tirar foto'),
          onTap: () => Navigator.pop(context, AvatarAction.camera),
        ),
        ListTile(
          leading: Icon(Icons.photo_library_outlined),
          title: Text('Escolher foto'),
          onTap: () => Navigator.pop(context, AvatarAction.gallery),
        ),
        if (hasAvatar)
          ListTile(
            leading: Icon(Icons.delete_outlined, color: colorScheme.error),
            title: Text(
              'Remover foto',
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () => Navigator.pop(context, AvatarAction.remove),
          ),

        const SizedBox(height: 8),
      ],
    );
  }
}
