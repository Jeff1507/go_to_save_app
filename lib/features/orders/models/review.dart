class Review {
  final String id;
  final int rating;
  final String? comment;
  final DateTime reviewedAt;

  Review({
    required this.id,
    required this.rating,
    this.comment,
    required this.reviewedAt,
  });

  bool get hasComment => comment?.trim().isNotEmpty ?? false;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      rating: json['rating'] as int,
      comment: (json['comment'] as String?),
      reviewedAt: DateTime.parse(json['reviewedAt'] as String).toLocal(),
    );
  }
}
