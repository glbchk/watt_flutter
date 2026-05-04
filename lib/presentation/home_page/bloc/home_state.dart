import 'package:geolocator/geolocator.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/payment_method_model.dart';
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
  final ChargingStationModel? chargingStation;
  final List<ChargingStationModel>? chargingStationsOnMap;
  final double? stationDistance;
  final Set<String> userStationIds;
  final Set<String> globalStationIds;
  final UserModel? userData;
  final bool clearUserData;
  final List<SlotModel>? selectedSlots;
  final List<SlotModel>? timeSlots;
  // final List<SlotModel> generatedSlots;
  final String? errorTimeIsNotChosen;
  // final ReservationStage? stage;
  final BookingModel? booking;
  final List<BookingModel>? bookings;
  // final BookingModel? activeBooking;
  // final bool isBooked;
  final List<MockedFaq>? faq;
  final List<CreditCardModel>? paymentMethods;
  final String? availableTime;

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
    this.chargingStation,
    this.chargingStationsOnMap,
    this.stationDistance,
    this.userStationIds = const {},
    this.globalStationIds = const {},
    this.userData,
    this.clearUserData = false,
    this.selectedSlots = const [],
    this.timeSlots,
    // this.generatedSlots = const [],
    this.errorTimeIsNotChosen,
    // this.stage,
    this.booking,
    this.bookings,
    // this.activeBooking,
    this.faq,
    this.paymentMethods,
    this.availableTime,
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
    ChargingStationModel? Function()? chargingStation,
    List<ChargingStationModel>? chargingStationsOnMap,
    double? stationDistance,
    Set<String>? userStationIds,
    Set<String>? globalStationIds,
    UserModel? userData,
    bool clearUserData = false,
    List<SlotModel>? Function()? selectedSlots,
    List<SlotModel>? timeSlots,
    // List<SlotModel>? Function()? generatedSlots,
    String? Function()? errorTimeIsNotChosen,
    // ReservationStage? Function()? stage,
    BookingModel? Function()? booking,
    List<BookingModel>? bookings,
    // BookingModel? Function()? activeBooking,
    List<MockedFaq>? faq,
    List<CreditCardModel>? paymentMethods,
    String? availableTime,
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
      chargingStation: chargingStation != null
          ? chargingStation()
          : this.chargingStation,
      chargingStationsOnMap:
          chargingStationsOnMap ?? this.chargingStationsOnMap,
      stationDistance: stationDistance ?? this.stationDistance,
      userStationIds: userStationIds ?? this.userStationIds,
      globalStationIds: globalStationIds ?? this.globalStationIds,
      userData: clearUserData ? null : (userData ?? this.userData),
      clearUserData: clearUserData,
      selectedSlots: selectedSlots != null
          ? selectedSlots()
          : this.selectedSlots,
      timeSlots: timeSlots ?? this.timeSlots,
      // generatedSlots: generatedSlots != null ? generatedSlots() : this.generatedSlots,
      errorTimeIsNotChosen: errorTimeIsNotChosen != null
          ? errorTimeIsNotChosen()
          : this.errorTimeIsNotChosen,
      // stage: stage != null ? stage() : this.stage,
      booking: booking != null ? booking() : this.booking,
      bookings: bookings ?? this.bookings,
      // activeBooking: activeBooking != null
      //     ? activeBooking()
      //     : this.activeBooking,
      // isBooked: isBooked ?? this.isBooked,
      faq: faq ?? this.faq,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      availableTime: availableTime ?? this.availableTime,
    );
  }
}
