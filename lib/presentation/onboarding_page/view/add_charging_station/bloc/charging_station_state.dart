import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/timeslot_model.dart';

class ChargingStationState {
  final bool isLoading;
  final String? errorMessage;

  final String? id;
  final String? chargingStationName;
  final String? address;
  final double? addressLatitude;
  final double? addressLongitude;
  // final Position? addressPosition;
  final List<String>? locationSuggestions;
  final String? brandName;
  final String? brandLogo;
  final String? chargingEffect;
  final String? plug;
  final String? pricePerKwh;
  final List<IbanModel>? bankAccounts;
  final bool? onlineCharger;
  final List<TimeSlotModel>? availableHours;
  final bool? everyoneCanAccess;

  final String? availableDaysError;
  final String? startTimeError;
  final String? endTimeError;
  final String? ibanError;

  final List<MockedChargingStationOption>? chargingStationOptions;
  final List<String>? chargingEffectOptions;
  final List<String>? plugOptions;
  final ChargingStationModel? chargingStation;
  final List<ChargingStationModel>? chargingStations;

  const ChargingStationState({
    this.isLoading = false,
    this.errorMessage,
    this.id,
    this.chargingStationName,
    this.address,
    this.addressLatitude,
    this.addressLongitude,
    // this.addressPosition,
    this.locationSuggestions,
    this.brandName,
    this.brandLogo,
    this.chargingEffect,
    this.plug,
    this.pricePerKwh,
    this.bankAccounts,
    this.onlineCharger = false,
    this.availableHours,
    this.everyoneCanAccess = false,
    this.availableDaysError,
    this.startTimeError,
    this.endTimeError,
    this.ibanError,
    this.chargingStationOptions,
    this.chargingEffectOptions,
    this.plugOptions,
    this.chargingStation,
    this.chargingStations,
  });

  ChargingStationState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? id,
    String? chargingStationName,
    String? Function()? address,
    double? Function()? addressLatitude,
    double? Function()? addressLongitude,
    List<String>? locationSuggestions,
    String? brandName,
    String? brandLogo,
    String? chargingEffect,
    String? plug,
    String? pricePerKwh,
    List<IbanModel>? bankAccounts,
    bool? onlineCharger,
    List<TimeSlotModel>? availableHours,
    bool? everyoneCanAccess,
    String? Function()? availableDaysError,
    String? Function()? startTimeError,
    String? Function()? endTimeError,
    String? Function()? ibanError,
    List<MockedChargingStationOption>? chargingStationOptions,
    List<String>? chargingEffectOptions,
    List<String>? plugOptions,
    ChargingStationModel? chargingStation,
    List<ChargingStationModel>? chargingStations,
  }) {
    return ChargingStationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      id: id ?? this.id,
      chargingStationName: chargingStationName ?? this.chargingStationName,
      address: address != null ? address() : this.address,
      addressLatitude: addressLatitude != null
          ? addressLatitude()
          : this.addressLatitude,
      addressLongitude: addressLongitude != null
          ? addressLongitude()
          : this.addressLongitude,
      // addressPosition: addressPosition != null
      //     ? addressPosition()
      //     : this.addressPosition,
      locationSuggestions: locationSuggestions ?? this.locationSuggestions,
      brandName: brandName ?? this.brandName,
      brandLogo: brandLogo ?? this.brandLogo,
      chargingEffect: chargingEffect ?? this.chargingEffect,
      plug: plug ?? this.plug,
      pricePerKwh: pricePerKwh ?? this.pricePerKwh,
      bankAccounts: bankAccounts ?? this.bankAccounts,
      onlineCharger: onlineCharger ?? this.onlineCharger,
      availableHours: availableHours ?? this.availableHours,
      everyoneCanAccess: everyoneCanAccess ?? this.everyoneCanAccess,
      availableDaysError: availableDaysError != null
          ? availableDaysError()
          : this.availableDaysError,
      startTimeError: startTimeError != null
          ? startTimeError()
          : this.startTimeError,
      endTimeError: endTimeError != null ? endTimeError() : this.endTimeError,
      ibanError: ibanError != null ? ibanError() : this.ibanError,
      chargingStationOptions:
          chargingStationOptions ?? this.chargingStationOptions,
      chargingEffectOptions:
          chargingEffectOptions ?? this.chargingEffectOptions,
      plugOptions: plugOptions ?? this.plugOptions,
      chargingStation: chargingStation ?? this.chargingStation,
      chargingStations: chargingStations ?? this.chargingStations,
    );
  }
}
