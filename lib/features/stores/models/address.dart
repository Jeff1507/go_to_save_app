class Address {
  final String postalCode;
  final String street;
  final String number;
  final String neighborhood;
  final String? complement;
  final String city;
  final String state;
  final double latitude;
  final double longitude;

  Address({
    required this.postalCode,
    required this.street,
    required this.number,
    required this.neighborhood,
    this.complement,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  String get formatted {
    final complementPart = complement != null ? ', $complement' : '';
    return '$street, $number$complementPart - $neighborhood, $city/$state';
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      postalCode: json['postalCode'] as String,
      street: json['street'] as String,
      number: json['number'] as String,
      neighborhood: json['neighborhood'] as String,
      complement: json['complement'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
