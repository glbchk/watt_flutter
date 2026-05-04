import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/slot_model.dart';
import 'package:watt/data/models/timeslot_model.dart';

enum ChargingStationAvailability {
  available,
  waiting,
  outOfService,
  busy
  ;

  String get label => switch (this) {
    ChargingStationAvailability.available => 'Available',
    ChargingStationAvailability.waiting => 'Waiting',
    ChargingStationAvailability.outOfService => 'Out of Service',
    ChargingStationAvailability.busy => 'Busy',
  };
}

enum ChargingStationType {
  public,
  private,
}

class ChargingStationModel {
  final ChargingStationType? type;
  final String id;
  final String? chargingStationName;
  final String? address;
  final double? addressLatitude;
  final double? addressLongitude;
  final String? brandName;
  final String? brandLogo;
  final String? chargingEffect;
  final String? plug;
  final String? pricePerKwh;
  final IbanModel? bankAccount;
  final bool? onlineCharger;
  final List<TimeSlotModel>? availableHours;
  final bool? everyoneCanAccess;
  final ChargingStationAvailability? stationStatus;
  final List<SlotModel>? slots;

  ChargingStationModel({
    this.type = ChargingStationType.private,
    required this.id,
    this.chargingStationName,
    this.address,
    this.addressLatitude,
    this.addressLongitude,
    this.brandName,
    this.brandLogo,
    this.chargingEffect,
    this.plug,
    this.pricePerKwh,
    this.bankAccount,
    this.onlineCharger,
    this.availableHours,
    this.everyoneCanAccess,
    this.stationStatus,
    this.slots,
  });

  factory ChargingStationModel.fromJson(Map<String, dynamic> json) {
    return ChargingStationModel(
      type: json['type'] == 'public'
          ? ChargingStationType.public
          : ChargingStationType.private,
      id: json['id'],
      chargingStationName: json['charging_station_name'],
      address: json['address'],
      addressLatitude: json['address_latitude'],
      addressLongitude: json['address_longitude'],
      brandName: json['brand_name'],
      brandLogo: json['brand_logo'],
      chargingEffect: json['charging_effect'],
      plug: json['plug'],
      pricePerKwh: json['price_per_kwh'],
      bankAccount: json['bank_account'] != null
          ? IbanModel.fromJson(json['bank_account'])
          : null,
      onlineCharger: json['online_charger'],
      availableHours: (json['available_hours'] as List<dynamic>?)
          ?.map((m) => TimeSlotModel.fromJson(m))
          .toList(),
      everyoneCanAccess: json['everyone_can_access'],
      stationStatus: ChargingStationAvailability.values.firstWhere(
        (s) => s.name == json['station_status'],
        orElse: () => ChargingStationAvailability.available,
      ),
      slots: (json['slots'] as List<dynamic>?)
          ?.map((s) => SlotModel.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type == ChargingStationType.public ? 'public' : 'private',
      'id': id,
      'charging_station_name': chargingStationName,
      'address': address,
      'address_latitude': addressLatitude,
      'address_longitude': addressLongitude,
      'brand_name': brandName,
      'brand_logo': brandLogo,
      'charging_effect': chargingEffect,
      'plug': plug,
      'price_per_kwh': pricePerKwh,
      'bank_account': bankAccount?.toJson(),
      'online_charger': onlineCharger,
      'available_hours': availableHours?.map((m) => m.toJson()).toList(),
      'everyone_can_access': everyoneCanAccess,
      'station_status': stationStatus?.name,
      'slots': slots?.map((s) => s.toJson()).toList(),
    };
  }

  ChargingStationModel copyChargingStationWith({
    ChargingStationType? type,
    String? id,
    String? chargingStationName,
    String? address,
    double? addressLatitude,
    double? addressLongitude,
    String? brandName,
    String? brandLogo,
    String? chargingEffect,
    String? plug,
    String? pricePerKwh,
    IbanModel? bankAccount,
    bool? onlineCharger,
    List<TimeSlotModel>? availableHours,
    bool? everyoneCanAccess,
    ChargingStationAvailability? stationStatus,
    List<SlotModel>? slots,
  }) {
    return ChargingStationModel(
      type: type ?? this.type,
      id: id ?? this.id,
      chargingStationName: chargingStationName ?? this.chargingStationName,
      address: address ?? this.address,
      addressLatitude: addressLatitude ?? this.addressLatitude,
      addressLongitude: addressLongitude ?? this.addressLongitude,
      brandName: brandName ?? this.brandName,
      brandLogo: brandLogo ?? this.brandLogo,
      chargingEffect: chargingEffect ?? this.chargingEffect,
      plug: plug ?? this.plug,
      pricePerKwh: pricePerKwh ?? this.pricePerKwh,
      bankAccount: bankAccount ?? this.bankAccount,
      onlineCharger: onlineCharger ?? this.onlineCharger,
      availableHours: availableHours ?? this.availableHours,
      everyoneCanAccess: everyoneCanAccess ?? this.everyoneCanAccess,
      stationStatus: stationStatus ?? this.stationStatus,
      slots: slots ?? this.slots,
    );
  }
}
