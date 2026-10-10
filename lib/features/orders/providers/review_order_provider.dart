import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_to_save_app/features/orders/providers/order_detail_provider.dart';
import 'package:go_to_save_app/features/orders/providers/order_repository_provider.dart';

class ReviewOrderNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() => null;

  Future<bool> reviewOrder({
    required String orderId,
    required int rating,
    String? comment,
  }) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() {
      return ref
          .read(orderRepositoryProvider)
          .reviewOrder(orderId: orderId, rating: rating, comment: comment);
    });

    if (state.hasError) return false;

    ref.invalidate(orderDetailProvider(orderId));

    return true;
  }
}

final reviewOrderProvider =
    AsyncNotifierProvider.autoDispose<ReviewOrderNotifier, void>(
      ReviewOrderNotifier.new,
    );
