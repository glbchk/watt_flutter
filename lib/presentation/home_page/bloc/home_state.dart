import 'package:geolocator/geolocator.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/slot_model.dart';
import 'package:watt/data/models/user_model.dart';

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
  // final ReservationStage? stage;
  final List<BookingModel>? bookings;
  // final BookingModel? activeBooking;
  // final bool isBooked;
  final List<MockedFaq>? faq;

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
    // this.stage,
    this.bookings,
    // this.activeBooking,
    this.faq,
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
    String? Function()? errorMessage,
    List<ChargingStationModel>? chargingStationsOnMap,
    double? stationDistance,
    UserModel? userData,
    bool clearUserData = false,
    Set<String>? Function()? selectedSlots,
    List<SlotModel>? timeSlots,
    String? Function()? errorTimeNotChosen,
    // ReservationStage? Function()? stage,
    List<BookingModel>? bookings,
    // BookingModel? Function()? activeBooking,
    List<MockedFaq>? faq,
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
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      chargingStationsOnMap:
          chargingStationsOnMap ?? this.chargingStationsOnMap,
      stationDistance: stationDistance ?? this.stationDistance,
      userData: clearUserData ? null : (userData ?? this.userData),
      clearUserData: clearUserData,
      selectedSlots:
          (selectedSlots != null ? selectedSlots() : this.selectedSlots) ??
          <String>{},
      timeSlots: timeSlots ?? this.timeSlots,
      errorTimeIsNotChosen: errorTimeNotChosen != null
          ? errorTimeNotChosen()
          : this.errorTimeIsNotChosen,
      // stage: stage != null ? stage() : this.stage,
      bookings: bookings ?? this.bookings,
      // activeBooking: activeBooking != null
      //     ? activeBooking()
      //     : this.activeBooking,
      // isBooked: isBooked ?? this.isBooked,
      faq: faq ?? this.faq,
    );
  }
}
