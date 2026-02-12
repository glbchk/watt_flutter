import 'package:watt/data/models/timeslot_model.dart';

class ChargingStationModel {
  final String? chargingStationName;
  final String? address;
  final String? brandName;
  final String? chargingEffect;
  final String? plug;
  final String? pricePerKwh;
  final String? iban;
  final bool? onlineCharger;
  final List<TimeslotModel>? availableHours;
  final bool? everyoneCanAccess;

  ChargingStationModel({
    this.chargingStationName,
    this.address,
    this.brandName,
    this.chargingEffect,
    this.plug,
    this.pricePerKwh,
    this.iban,
    this.onlineCharger,
    this.availableHours,
    this.everyoneCanAccess,
  });

  factory ChargingStationModel.fromJson(Map<String, dynamic> json) {
    return ChargingStationModel(
      chargingStationName: json['charging_station_name'],
      address: json['address'],
      brandName: json['brand_name'],
      chargingEffect: json['charging_effect'],
      plug: json['plug'],
      pricePerKwh: json['price_per_kwh'],
      iban: json['iban'],
      onlineCharger: json['online_charger'],
      availableHours: json['available_hours'],
      everyoneCanAccess: json['everyone_can_access'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'charging_station_name': chargingStationName,
      'address': address,
      'brand_name': brandName,
      'charging_effect': chargingEffect,
      'plug': plug,
      'price_per_kwh': pricePerKwh,
      'iban': iban,
      'online_charger': onlineCharger,
      'available_hours': availableHours,
      'everyone_can_access': everyoneCanAccess,
    };
  }
}
