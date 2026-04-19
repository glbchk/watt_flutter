import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/user_model.dart';

class MyChargingStationsState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final String? errorMessage;
  final List<ChargingStationModel>? userChargingStations;
  final UserModel? userData;

  final List<MockedChargingStationOption>? chargingStationOptions;
  final List<String>? chargingEffectOptions;
  final List<String>? plugOptions;
  final ChargingStationModel? chargingStation;
  final List<ChargingStationModel>? chargingStations;
  final List<String>? locationSuggestions;

  final String? ibanError;
  final String? startTimeError;
  final String? endTimeError;
  final String? availableDaysError;

  MyChargingStationsState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.errorMessage,
    this.userChargingStations,
    this.userData,
    this.chargingStationOptions,
    this.chargingEffectOptions,
    this.plugOptions,
    this.chargingStation,
    this.chargingStations,
    this.locationSuggestions,
    this.ibanError,
    this.startTimeError,
    this.endTimeError,
    this.availableDaysError,
  });

  MyChargingStationsState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    String? errorMessage,
    List<ChargingStationModel>? userChargingStations,
    UserModel? userData,
    bool clearUserData = false,
    List<MockedChargingStationOption>? chargingStationOptions,
    List<String>? chargingEffectOptions,
    List<String>? plugOptions,
    ChargingStationModel? chargingStation,
    List<ChargingStationModel>? chargingStations,
    List<String>? locationSuggestions,
    String? Function()? ibanError,
    String? Function()? startTimeError,
    String? Function()? endTimeError,
    String? Function()? availableDaysError,
  }) {
    return MyChargingStationsState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      userChargingStations: userChargingStations ?? this.userChargingStations,
      userData: clearUserData ? null : (userData ?? this.userData),
      chargingStationOptions:
          chargingStationOptions ?? this.chargingStationOptions,
      chargingEffectOptions:
          chargingEffectOptions ?? this.chargingEffectOptions,
      plugOptions: plugOptions ?? this.plugOptions,
      chargingStation: chargingStation ?? this.chargingStation,
      chargingStations: chargingStations ?? this.chargingStations,
      locationSuggestions: locationSuggestions ?? this.locationSuggestions,
      ibanError: ibanError != null ? ibanError() : this.ibanError,
      startTimeError: startTimeError != null
          ? startTimeError()
          : this.startTimeError,
      endTimeError: endTimeError != null ? endTimeError() : this.endTimeError,
      availableDaysError: availableDaysError != null
          ? availableDaysError()
          : this.availableDaysError,
    );
  }
}
