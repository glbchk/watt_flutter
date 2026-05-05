import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';

class ReservationsState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final bool? isLocationEnabled;
  final String? errorMessage;
  final String? nameError;
  final String? emailError;
  final String? phoneNumberError;
  final String? newEmailValue;
  final String? passwordError;
  final List<BookingModel>? bookings;
  final List<ChargingStationModel>? bookedChargingStations;

  ReservationsState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.isLocationEnabled,
    this.errorMessage,
    this.nameError,
    this.emailError,
    this.phoneNumberError,
    this.newEmailValue,
    this.passwordError,
    this.bookings,
    this.bookedChargingStations,
  });

  ReservationsState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    bool? isLocationEnabled,
    String? Function()? errorMessage,
    bool clearUserData = false,
    String? Function()? nameError,
    String? Function()? emailError,
    String? Function()? phoneNumberError,
    String? Function()? newEmailValue,
    String? Function()? passwordError,
    List<BookingModel>? bookings,
    List<ChargingStationModel>? bookedChargingStations,
  }) {
    return ReservationsState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      nameError: nameError != null ? nameError() : this.nameError,
      emailError: emailError != null ? emailError() : this.emailError,
      phoneNumberError: phoneNumberError != null
          ? phoneNumberError()
          : this.phoneNumberError,
      newEmailValue: newEmailValue != null
          ? newEmailValue()
          : this.newEmailValue,
      passwordError: passwordError != null
          ? passwordError()
          : this.passwordError,
      bookings: bookings ?? this.bookings,
      bookedChargingStations:
          bookedChargingStations ?? this.bookedChargingStations,
    );
  }
}
