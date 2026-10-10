enum OrderStatus {
  pending,
  completed,
  cancelled,
  noShow,
  unknown;

  static OrderStatus fromJson(String value) {
    switch (value) {
      case 'PENDING':
        return OrderStatus.pending;
      case 'COMPLETED':
        return OrderStatus.completed;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      case 'NO_SHOW':
        return OrderStatus.noShow;
      default:
        return OrderStatus.unknown;
    }
  }
}
