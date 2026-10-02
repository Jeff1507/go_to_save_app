import 'package:flutter/material.dart';
import 'package:go_to_save_app/core/http/resolve_media_url.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;

  const UserAvatar(this.avatarUrl, {super.key, this.size = 120});

  Widget _buildFallback(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/images/cachorrao.jpg',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = resolveMediaUrl(avatarUrl);

    if (resolvedUrl == null || resolvedUrl.isEmpty) {
      return _buildFallback(context);
    }

    return ClipOval(
      child: Image.network(
        resolvedUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, _, _) => _buildFallback(context),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
