class SessionModel {
  final String id;

  SessionModel({required this.id});

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(id: json['sessionId'] as String);
  }
}
