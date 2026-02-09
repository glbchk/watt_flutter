import 'package:watt/data/models/car_model.dart';

class OnboardingState {
  final String? name;
  final String? phoneNumber;
  final String? nameError;
  final String? phoneNumberError;
  final bool? isNameValid;
  final bool? isPhoneNumberValid;
  final List<CarModel>? cars;

  OnboardingState({
    this.name,
    this.phoneNumber,
    this.nameError,
    this.phoneNumberError,
    this.isNameValid = false,
    this.isPhoneNumberValid = false,
    this.cars,
  });

  OnboardingState copyWith({
    String? Function()? name,
    String? Function()? phoneNumber,
    String? Function()? nameError,
    String? Function()? phoneNumberError,
    bool? Function()? isNameValid,
    bool? Function()? isPhoneNumberValid,
    List<CarModel>? Function()? cars,
  }) {
    return OnboardingState(
      name: name != null ? name() : this.name,
      phoneNumber: phoneNumber != null ? phoneNumber() : this.phoneNumber,
      nameError: nameError != null ? nameError() : this.nameError,
      phoneNumberError: phoneNumberError != null
          ? phoneNumberError()
          : this.phoneNumberError,
      isNameValid: isNameValid != null ? isNameValid() : this.isNameValid,
      isPhoneNumberValid: isPhoneNumberValid != null
          ? isPhoneNumberValid()
          : this.isPhoneNumberValid,
      cars: cars != null ? cars() : this.cars,
    );
  }
}

// class Wrapper<T> {
//   final T value;
//   const Wrapper.value(this.value);
// }
