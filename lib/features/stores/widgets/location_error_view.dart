import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_to_save_app/core/geolocation/location_service.dart';
import 'package:go_to_save_app/shared/widgets/error_state_view.dart';

class LocationErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const LocationErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  IconData get _icon {
    if (error is AppLocationServiceDisabledException) {
      return Icons.location_off_outlined;
    }
    if (error is AppLocationPermissionDeniedException ||
        error is AppLocationPermissionDeniedForeverException) {
      return Icons.location_disabled_outlined;
    }

    return Icons.error_outlined;
  }

  String get _message {
    if (error is AppLocationServiceDisabledException) {
      return 'Ative a localização do seu aparelho para ver lojas próximas.';
    }
    if (error is AppLocationPermissionDeniedException) {
      return 'Precisamos da sua localização para mostrar lojas próximas.';
    }
    if (error is AppLocationPermissionDeniedForeverException) {
      return 'A permissão de localização foi negada. Ative-a nas configurações do app.';
    }

    return 'Não foi possível carregar as lojas próximas.';
  }

  bool get _isDeniedForever =>
      error is AppLocationPermissionDeniedForeverException;

  @override
  Widget build(BuildContext context) {
    return ErrorStateView(
      icon: _icon,
      message: _message,
      actionLabel: _isDeniedForever
          ? 'Abrir configurações'
          : 'Tentar novamente',
      onAction: _isDeniedForever ? () => Geolocator.openAppSettings() : onRetry,
    );
  }
}
