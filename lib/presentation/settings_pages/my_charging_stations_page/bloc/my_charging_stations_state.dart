import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/user_model.dart';

class MyChargingStationsState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final String? errorMessage;
  final List<ChargingStationModel>? userChargingStations;
  final UserModel? userData;
  // final List<MockedCarOption>? carOptions;
  // final Map<MockedCarBrand, List<String>>? carModelOptions;

  final List<MockedChargingStationOption>? chargingStationOptions;
  final List<String>? chargingEffectOptions;
  final List<String>? plugOptions;
  final ChargingStationModel? chargingStation;
  final List<ChargingStationModel>? chargingStations;

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
    // this.carOptions,
    // this.carModelOptions,
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
    // List<MockedCarOption>? carOptions,
    // Map<MockedCarBrand, List<String>>? carModelOptions,
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
      // carOptions: carOptions ?? this.carOptions,
      // carModelOptions: carModelOptions ?? this.carModelOptions,
    );
  }
}
