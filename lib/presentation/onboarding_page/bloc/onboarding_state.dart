import 'package:equatable/equatable.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';

class OnboardingState extends Equatable {
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
    );
  }

  @override
  List<Object?> get props => [cars, chargingStations, isLoading, errorMessage];
}
