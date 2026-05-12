import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/reservation_model.dart';

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
  final ChargingStationModel? reservedChargingStation;
  final List<ReservationModel>? upcomingReservations;
  final List<ReservationModel>? pastReservations;
  final List<ChargingStationModel>? reservedChargingStations;
  final List<BookingModel>? upcomingBookings;
  final List<BookingModel>? pastBookings;

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
    this.reservedChargingStation,
    this.upcomingReservations,
    this.pastReservations,
    this.reservedChargingStations,
    this.upcomingBookings,
    this.pastBookings,
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
    ChargingStationModel? Function()? reservedChargingStation,
    List<ReservationModel>? upcomingReservations,
    List<ReservationModel>? pastReservations,
    List<ChargingStationModel>? reservedChargingStations,
    List<BookingModel>? upcomingBookings,
    List<BookingModel>? pastBookings,
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
      reservedChargingStation: reservedChargingStation != null
          ? reservedChargingStation()
          : this.reservedChargingStation,
      upcomingReservations: upcomingReservations ?? this.upcomingReservations,
      pastReservations: pastReservations ?? this.pastReservations,
      reservedChargingStations:
          reservedChargingStations ?? this.reservedChargingStations,
      upcomingBookings: upcomingBookings ?? this.upcomingBookings,
      pastBookings: pastBookings ?? this.pastBookings,
    );
  }
}
