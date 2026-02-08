import 'package:watt/data/models/car_model.dart';

class OnboardingState {
  final String? name;
  final String? phoneNumber;
  final String? nameError;
  final String? phoneNumberError;
  final bool isNameValid;
  final bool isPhoneNumberValid;
  final CarModel? car;

  OnboardingState({
    this.name,
    this.phoneNumber,
    this.nameError,
    this.phoneNumberError,
    this.isNameValid = false,
    this.isPhoneNumberValid = false,
    this.car,
  });

  OnboardingState copyWith({
    String? name,
    String? phoneNumber,
    String? nameError,
    String? phoneNumberError,
    bool? isNameValid,
    bool? isPhoneNumberValid,
    CarModel? car,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nameError: nameError ?? this.nameError,
      phoneNumberError: phoneNumberError ?? this.phoneNumberError,
      isNameValid: isNameValid ?? this.isNameValid,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      car: car ?? this.car,
    );
  }
}
