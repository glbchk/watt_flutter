class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String language;
  final List<String> paymentMethods; //Need to have a model - Payment Method
  final List<String> cars; //Need to have a model - Car
  final List<String> chargingStations; //Need to have a model - Charging Station

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.language,
    required this.paymentMethods,
    required this.cars,
    required this.chargingStations,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      language: json['language'],
      paymentMethods: ['payment_methods'],
      cars: json['cars'],
      chargingStations: json['charging_stations'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'language': language,
      'payment_methods': paymentMethods,
      'cars': cars,
      'charging_stations': chargingStations,
    };
  }

  UserModel copyUserWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? language,
    List<String>? paymentMethods,
    List<String>? cars,
    List<String>? chargingStations,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      language: language ?? this.language,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      cars: cars ?? this.cars,
      chargingStations: chargingStations ?? this.chargingStations,
    );
  }
}
