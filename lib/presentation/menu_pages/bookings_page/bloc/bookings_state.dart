import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';

class BookingsState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final bool? isLocationEnabled;
  final String? errorMessage;
  final ChargingStationModel? bookedChargingStation;
  final List<BookingModel>? upcomingBookings;
  final List<BookingModel>? pastBookings;
  final List<ChargingStationModel>? bookedChargingStations;

  BookingsState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.isLocationEnabled,
    this.errorMessage,
    this.bookedChargingStation,
    this.upcomingBookings,
    this.pastBookings,
    this.bookedChargingStations,
  });

  BookingsState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    bool? isLocationEnabled,
    String? Function()? errorMessage,
    ChargingStationModel? Function()? bookedChargingStation,
    List<BookingModel>? upcomingBookings,
    List<BookingModel>? pastBookings,
    List<ChargingStationModel>? bookedChargingStations,
  }) {
    return BookingsState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      bookedChargingStation: bookedChargingStation != null
          ? bookedChargingStation()
          : this.bookedChargingStation,
      upcomingBookings: upcomingBookings ?? this.upcomingBookings,
      pastBookings: pastBookings ?? this.pastBookings,
      bookedChargingStations:
          bookedChargingStations ?? this.bookedChargingStations,
    );
  }
}
