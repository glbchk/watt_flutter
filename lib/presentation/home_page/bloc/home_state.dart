import 'package:geolocator/geolocator.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/slot_model.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/presentation/home_page/view/sub_pages/stages/reservation_requested_widget.dart';

class HomeState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final bool? isLocationEnabled;
  final Position? myLocation;
  final String? address;
  final double? addressLatitude;
  final double? addressLongitude;
  final List<String>? locationSuggestions;
  final String? errorMessage;
  final List<ChargingStationModel>? chargingStationsOnMap;
  final double? stationDistance;
  final UserModel? userData;
  final bool clearUserData;
  final Set<String> selectedSlots;
  final List<SlotModel>? timeSlots;
  final String? errorTimeIsNotChosen;
  final ReservationStage? stage;
  final List<BookingModel>? bookings;

  HomeState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.isLocationEnabled,
    this.myLocation,
    this.address,
    this.addressLatitude,
    this.addressLongitude,
    this.locationSuggestions,
    this.errorMessage,
    this.chargingStationsOnMap,
    this.stationDistance,
    this.userData,
    this.clearUserData = false,
    this.selectedSlots = const {},
    this.timeSlots,
    this.errorTimeIsNotChosen,
    this.stage,
    this.bookings,
  });

  HomeState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    bool? isLocationEnabled,
    Position? myLocation,
    String? address,
    double? addressLatitude,
    double? addressLongitude,
    List<String>? locationSuggestions,
    String? errorMessage,
    List<ChargingStationModel>? chargingStationsOnMap,
    double? stationDistance,
    UserModel? userData,
    bool clearUserData = false,
    Set<String>? selectedSlots,
    List<SlotModel>? timeSlots,
    String? Function()? errorTimeNotChosen,
    ReservationStage? stage,
    List<BookingModel>? bookings,
  }) {
    return HomeState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      myLocation: myLocation ?? this.myLocation,
      address: address ?? this.address,
      addressLatitude: addressLatitude ?? this.addressLatitude,
      addressLongitude: addressLongitude ?? this.addressLongitude,
      locationSuggestions: locationSuggestions ?? this.locationSuggestions,
      errorMessage: errorMessage,
      chargingStationsOnMap:
          chargingStationsOnMap ?? this.chargingStationsOnMap,
      stationDistance: stationDistance ?? this.stationDistance,
      userData: clearUserData ? null : (userData ?? this.userData),
      clearUserData: clearUserData,
      selectedSlots: selectedSlots ?? this.selectedSlots,
      timeSlots: timeSlots ?? this.timeSlots,
      errorTimeIsNotChosen: errorTimeNotChosen != null
          ? errorTimeNotChosen()
          : this.errorTimeIsNotChosen,
      stage: stage ?? this.stage,
      bookings: bookings ?? this.bookings,
    );
  }
}
