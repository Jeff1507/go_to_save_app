class Session {
  final String id;

  Session({required this.id});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(id: json['sessionId'] as String);
  }
}
