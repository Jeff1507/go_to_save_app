import 'package:flutter/material.dart';
import 'package:go_to_save_app/features/orders/models/order_status.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  ({String label, Color color}) get _config {
    switch (status) {
      case OrderStatus.pending:
        return (label: 'Pendente', color: Colors.orange.shade700);
      case OrderStatus.completed:
        return (label: 'Concluído', color: Colors.green.shade700);
      case OrderStatus.cancelled:
        return (label: 'Cancelado', color: Colors.red.shade700);
      case OrderStatus.noShow:
        return (label: 'Não comparecido', color: Colors.red.shade700);
      case OrderStatus.unknown:
        return (label: 'Desconhecido', color: Colors.grey.shade700);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
