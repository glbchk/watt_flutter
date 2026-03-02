import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
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
  final List<CarModel>? cars;
  final List<ChargingStationModel>? chargingStations;
  final List<PaymentMethodModel>? paymentMethods;

  UserModel({
    this.isAnonymous,
    required this.id,
    this.name,
    this.email,
    this.isEmailVerified,
    this.phoneNumber,
    required this.isOnboardingCompleted,
    this.language,
    this.cars,
    this.chargingStations,
    this.paymentMethods,
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

      cars:
          (json['cars'] as List<dynamic>?)
              ?.map((item) => CarModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      chargingStations:
          (json['charging_stations'] as List<dynamic>?)
              ?.map(
                (item) =>
                    ChargingStationModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      paymentMethods:
          (json['payment_methods'] as List<dynamic>?)
              ?.map(
                (item) =>
                    PaymentMethodModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
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
      'cars': cars?.map((c) => c.toJson()).toList(),
      'charging_stations': chargingStations?.map((c) => c.toJson()).toList(),
      'payment_methods': paymentMethods?.map((m) => m.toJson()).toList(),
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
      isOnboardingCompleted: entity.isOnboardingCompleted,
      language: entity.language ?? '',
      cars: entity.cars ?? [],
      chargingStations: entity.chargingStations ?? [],
      paymentMethods: entity.paymentMethods ?? [],
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
    List<CarModel>? cars,
    List<ChargingStationModel>? chargingStations,
    List<PaymentMethodModel>? paymentMethods,
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
      cars: cars ?? this.cars,
      chargingStations: chargingStations ?? this.chargingStations,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }
}
