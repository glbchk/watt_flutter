import 'package:watt/data/models/car_model.dart';

class UserEntity {
  final bool? isAnonymous;
  final String id;
  final String? name;
  final String? email;
  final bool? isEmailVerified;
  final String? phoneNumber;
  final bool isOnboardingCompleted;
  final String? language;
  final List<String>? paymentMethods;
  final List<CarModel>? cars;
  final List<String>? chargingStations;

  UserEntity({
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
}
