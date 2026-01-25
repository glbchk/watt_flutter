import 'package:watt/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.language,
    required super.paymentMethods,
    required super.cars,
    required super.chargingStations,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      language: json['language'] ?? 'en',
      paymentMethods: List<String>.from(json['payment_methods'] ?? []),
      cars: List<String>.from(json['cars'] ?? []),
      chargingStations: List<String>.from(json['charging_stations'] ?? []),
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

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      language: entity.language,
      paymentMethods: entity.paymentMethods,
      cars: entity.cars,
      chargingStations: entity.chargingStations,
    );
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
