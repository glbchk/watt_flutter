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
    this.isNameValid = false,
    this.isPhoneNumberValid = false,
    this.cars,
    this.chargingStations,
    this.paymentMethods,
  });

  OnboardingState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? Function()? name,
    String? Function()? phoneNumber,
    String? Function()? nameError,
    String? Function()? phoneNumberError,
    bool? Function()? isNameValid,
    bool? Function()? isPhoneNumberValid,
    List<CarModel>? Function()? cars,
    List<ChargingStationModel>? Function()? chargingStations,
    List<PaymentMethodModel>? Function()? paymentMethods,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
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
      chargingStations: chargingStations != null
          ? chargingStations()
          : this.chargingStations,
      paymentMethods: paymentMethods != null
          ? paymentMethods()
          : this.paymentMethods,
    );
  }
}
