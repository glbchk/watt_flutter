import 'package:watt/data/models/timeslot_model.dart';

class ChargingStationModel {
  final String id;
  final String? chargingStationName;
  final String? address;
  final String? brandName;
  final String? chargingEffect;
  final String? plug;
  final String? pricePerKwh;
  final String? bankAccount;
  final bool? onlineCharger;
  final List<TimeSlotModel>? availableHours;
  final bool? everyoneCanAccess;

  ChargingStationModel({
    required this.id,
    this.chargingStationName,
    this.address,
    this.brandName,
    this.chargingEffect,
    this.plug,
    this.pricePerKwh,
    this.bankAccount,
    this.onlineCharger,
    this.availableHours,
    this.everyoneCanAccess,
  });

  factory ChargingStationModel.fromJson(Map<String, dynamic> json) {
    return ChargingStationModel(
      id: json['id'],
      chargingStationName: json['charging_station_name'],
      address: json['address'],
      brandName: json['brand_name'],
      chargingEffect: json['charging_effect'],
      plug: json['plug'],
      pricePerKwh: json['price_per_kwh'],
      bankAccount: json['bank_account'],
      onlineCharger: json['online_charger'],
      availableHours: json['available_hours'],
      everyoneCanAccess: json['everyone_can_access'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'charging_station_name': chargingStationName,
      'address': address,
      'brand_name': brandName,
      'charging_effect': chargingEffect,
      'plug': plug,
      'price_per_kwh': pricePerKwh,
      'bank_account': bankAccount,
      'online_charger': onlineCharger,
      'available_hours': availableHours,
      'everyone_can_access': everyoneCanAccess,
    };
  }

  ChargingStationModel copyChargingStationWith({
    String? id,
    String? chargingStationName,
    String? address,
    String? brandName,
    String? chargingEffect,
    String? plug,
    String? pricePerKwh,
    String? bankAccount,
    bool? onlineCharger,
    List<TimeSlotModel>? availableHours,
    bool? everyoneCanAccess,
  }) {
    return ChargingStationModel(
      id: id ?? this.id,
      chargingStationName: chargingStationName ?? this.chargingStationName,
      address: address ?? this.address,
      brandName: brandName ?? this.brandName,
      chargingEffect: chargingEffect ?? this.chargingEffect,
      plug: plug ?? this.plug,
      pricePerKwh: pricePerKwh ?? this.pricePerKwh,
      bankAccount: bankAccount ?? this.bankAccount,
      onlineCharger: onlineCharger ?? this.onlineCharger,
      availableHours: availableHours ?? this.availableHours,
      everyoneCanAccess: everyoneCanAccess ?? this.everyoneCanAccess,
    );
  }
}
