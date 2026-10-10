class PickupWindow {
  final DateTime start;
  final DateTime end;

  PickupWindow({required this.start, required this.end});

  @override
  bool operator ==(Object other) =>
      other is PickupWindow && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  /// Preserva o horário exatamente como a loja cadastrou,
  /// independente do fuso configurado no aparelho do usuário.
  static DateTime _parseAsWallClock(String iso) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})')
        .firstMatch(iso);

    if (match == null) {
      throw FormatException('Formato de data inválido: $iso');
    }

    return DateTime(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.parse(match.group(6)!),
    );
  }

  factory PickupWindow.fromJson(Map<String, dynamic> json) {
    return PickupWindow(
      start: _parseAsWallClock(json['start'] as String),
      end: _parseAsWallClock(json['end'] as String).toLocal(),
    );
  }
}
