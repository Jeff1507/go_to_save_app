class Rating {
  final double average;
  final int count;

  Rating({required this.average, required this.count});

  bool get hasRatings => count > 0;

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      average: (json['average'] as num).toDouble(),
      count: json['count'] as int,
    );
  }
}
