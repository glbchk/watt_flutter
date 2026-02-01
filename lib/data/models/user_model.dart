import 'package:watt/domain/entities/user_entity.dart';

class UserModel {
  final bool? isAnonymous;
  final String id;
  final String? name;
  final String? email;
  final bool? isEmailVerified;
  final String? phoneNumber;
  final bool isOnboardingCompleted;
  final String? language;
  final List<String>? paymentMethods;
  final List<String>? cars;
  final List<String>? chargingStations;

  UserModel({
    this.isAnonymous,
    required this.id,
    this.name,
    this.email,
    this.isEmailVerified,
    this.phoneNumber,
    required this.isOnboardingCompleted,
    this.language,
    this.paymentMethods,
    this.cars,
    this.chargingStations,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      isAnonymous: json['is_anonymous'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isEmailVerified: json['is_email_verified'] ?? false,
      phoneNumber: json['phone_number'] ?? '',
      isOnboardingCompleted: json['is_onboarding_completed'],
      language: json['language'] ?? 'en',
      paymentMethods: List<String>.from(json['payment_methods'] ?? []),
      cars: List<String>.from(json['cars'] ?? []),
      chargingStations: List<String>.from(json['charging_stations'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_anonymous': isAnonymous,
      'id': id,
      'name': name,
      'email': email,
      'is_email_verified': isEmailVerified,
      'phone_number': phoneNumber,
      'is_onboarding_completed': isOnboardingCompleted,
      'language': language,
      'payment_methods': paymentMethods,
      'cars': cars,
      'charging_stations': chargingStations,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      isAnonymous: entity.isAnonymous ?? false,
      id: entity.id,
      name: entity.name ?? '',
      email: entity.email,
      isEmailVerified: entity.isEmailVerified ?? false,
      phoneNumber: entity.phoneNumber ?? '',
      isOnboardingCompleted: entity.isOnboardingCompleted ?? false,
      language: entity.language ?? '',
      paymentMethods: entity.paymentMethods ?? [],
      cars: entity.cars ?? [],
      chargingStations: entity.chargingStations ?? [],
    );
  }

  UserModel copyUserWith({
    bool? isAnonymous,
    String? id,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? phoneNumber,
    bool? isOnboardingCompleted,
    String? language,
    List<String>? paymentMethods,
    List<String>? cars,
    List<String>? chargingStations,
  }) {
    return UserModel(
      isAnonymous: isAnonymous ?? this.isAnonymous,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      language: language ?? this.language,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      cars: cars ?? this.cars,
      chargingStations: chargingStations ?? this.chargingStations,
    );
  }
}
