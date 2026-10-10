import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/core/http/api_provider.dart';
import 'package:go_to_save_app/features/orders/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.read(apiProvider));
});
