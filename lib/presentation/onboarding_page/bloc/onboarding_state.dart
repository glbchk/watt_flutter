import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';

class OnboardingState {
  final bool isLoading;
  final String? errorMessage;

  final String? name;
  final String? phoneNumber;
  final String? nameError;
  final String? phoneNumberError;
  final bool? isNameValid;
  final bool? isPhoneNumberValid;
  final List<CarModel>? cars;
  final List<ChargingStationModel>? chargingStations;
  final List<PaymentMethodModel>? paymentMethods;

  OnboardingState({
    this.isLoading = false,
    this.errorMessage,
    this.name,
    this.phoneNumber,
    this.nameError,
    this.phoneNumberError,
    this.isNameValid,
    this.isPhoneNumberValid,
    this.cars,
    this.chargingStations,
    this.paymentMethods,
  });

  OnboardingState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? name,
    String? phoneNumber,
    String? nameError,
    String? phoneNumberError,
    bool? isNameValid,
    bool? isPhoneNumberValid,
    List<CarModel>? cars,
    List<ChargingStationModel>? chargingStations,
    List<PaymentMethodModel>? paymentMethods,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nameError: nameError != null
          ? (nameError.isEmpty ? null : nameError)
          : this.nameError,
      phoneNumberError: phoneNumberError != null
          ? (phoneNumberError.isEmpty ? null : phoneNumberError)
          : this.phoneNumberError,
      isNameValid: isNameValid ?? this.isNameValid,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      cars: cars ?? this.cars,
      chargingStations: chargingStations ?? this.chargingStations,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }
}
