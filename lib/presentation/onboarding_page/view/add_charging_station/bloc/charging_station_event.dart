import 'package:equatable/equatable.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/details_page.dart';

abstract class ChargingStationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SaveBrandNameChargingStationEvent extends ChargingStationEvent {
  final String brandName;
  final String brandLogo;

  SaveBrandNameChargingStationEvent(this.brandName, this.brandLogo);
}

// class SaveAddressChargingStationEvent extends ChargingStationEvent {
//   final String address;
//
//   SaveAddressChargingStationEvent(this.address);
// }

class UpdateChargingStationPropertyEvent extends ChargingStationEvent {
  final DetailPageProperties property;
  final String value;

  UpdateChargingStationPropertyEvent(this.property, this.value);
}

class AddChargingStationEvent extends ChargingStationEvent {
  final ChargingStationModel chargingStation;

  AddChargingStationEvent(this.chargingStation);
}

class UpdateChargingStationEvent extends ChargingStationEvent {
  final String chargingStationId;

  UpdateChargingStationEvent({
    required this.chargingStationId,
  });
}

class OnboardingFilledChargingStationEvent extends ChargingStationEvent {
  final ChargingStationModel chargingStation;

  OnboardingFilledChargingStationEvent({
    required this.chargingStation,
  });
}
