import 'package:geolocator/geolocator.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/timeslot_model.dart';

class ChargingStationState {
  final bool? isLoading;
  final String? errorMessage;

  final String? id;
  final String? chargingStationName;
  final String? address;
  final Position? addressPosition;
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

  final ChargingStationModel? chargingStation;
  final List<ChargingStationModel>? chargingStations;

  const ChargingStationState({
    this.isLoading = false,
    this.errorMessage,
    this.id,
    this.chargingStationName,
    this.address,
    this.addressPosition,
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
    this.chargingStation,
    this.chargingStations,
  });

  ChargingStationState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? id,
    String? chargingStationName,
    String? Function()? address,
    Position? Function()? addressPosition,
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
    ChargingStationModel? chargingStation,
    List<ChargingStationModel>? chargingStations,
  }) {
    return ChargingStationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      id: id ?? this.id,
      chargingStationName: chargingStationName ?? this.chargingStationName,
      address: address != null ? address() : this.address,
      addressPosition: addressPosition != null
          ? addressPosition()
          : this.addressPosition,
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
      chargingStation: chargingStation ?? this.chargingStation,
      chargingStations: chargingStations ?? this.chargingStations,
    );
  }
}
