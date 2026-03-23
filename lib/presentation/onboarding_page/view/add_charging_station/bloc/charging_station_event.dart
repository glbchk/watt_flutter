import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/timeslot_model.dart';

abstract class ChargingStationEvent {}

class FetchMockedChargingStationOptionsEvent extends ChargingStationEvent {}

class SaveBrandNameChargingStationEvent extends ChargingStationEvent {
  final String brandName;
  final String brandLogo;

  SaveBrandNameChargingStationEvent(this.brandName, this.brandLogo);
}

class SaveNamePropertyEvent extends ChargingStationEvent {
  final String value;

  SaveNamePropertyEvent(
    this.value,
  );
}

class GoToMyLocationEvent extends ChargingStationEvent {}

class SearchLocationEvent extends ChargingStationEvent {
  final String address;
  final GoogleMapController? mapController;

  SearchLocationEvent(
    this.address,
    this.mapController,
  );
}

class HandleMapTapEvent extends ChargingStationEvent {
  final LatLng tappedPoint;

  HandleMapTapEvent(
    this.tappedPoint,
  );
}

class ChooseLocationOnMapEvent extends ChargingStationEvent {}

class FetchLocationSuggestionsEvent extends ChargingStationEvent {
  final String value;

  FetchLocationSuggestionsEvent(
    this.value,
  );
}

class SaveAddressPropertyEvent extends ChargingStationEvent {
  final String value;
  final Position? addressPosition;

  SaveAddressPropertyEvent(
    this.value,
    this.addressPosition,
  );
}

class ClearAddressPropertyEvent extends ChargingStationEvent {}

class UpdateBrandNamePropertyEvent extends ChargingStationEvent {
  final String value;
  final String brandLogo;

  UpdateBrandNamePropertyEvent(
    this.value,
    this.brandLogo,
  );
}

class FetchMockedChargingEffectOptionsEvent extends ChargingStationEvent {}

class SaveChargingEffectPropertyEvent extends ChargingStationEvent {
  final String value;

  SaveChargingEffectPropertyEvent(
    this.value,
  );
}

class FetchMockedPlugOptionsEvent extends ChargingStationEvent {}

class SavePlugPropertyEvent extends ChargingStationEvent {
  final String value;

  SavePlugPropertyEvent(
    this.value,
  );
}

class SavePricePropertyEvent extends ChargingStationEvent {
  final String value;

  SavePricePropertyEvent(
    this.value,
  );
}

class UpdateChargingStationPropertyEvent extends ChargingStationEvent {
  final String value;
  final IbanModel? iban;
  final List<TimeSlotModel>? timeSlots;

  UpdateChargingStationPropertyEvent(
    this.value,
    this.iban,
    this.timeSlots,
  );
}

class IbanVerificationEvent extends ChargingStationEvent {
  final String value;

  IbanVerificationEvent({
    required this.value,
  });
}

class AddIbanEvent extends ChargingStationEvent {
  final IbanModel iban;

  AddIbanEvent({
    required this.iban,
  });
}

class RemoveIbanEvent extends ChargingStationEvent {
  final String ibanId;

  RemoveIbanEvent(this.ibanId);
}

class AvailableHoursVerificationEvent extends ChargingStationEvent {
  final List<int> availableDays;
  final String startTime;
  final String endTime;

  AvailableHoursVerificationEvent({
    required this.availableDays,
    required this.startTime,
    required this.endTime,
  });
}

class AddTimeSlotEvent extends ChargingStationEvent {
  final TimeSlotModel timeSlot;

  AddTimeSlotEvent(this.timeSlot);
}

class RemoveTimeSlotEvent extends ChargingStationEvent {
  final String timeSlotId;

  RemoveTimeSlotEvent(this.timeSlotId);
}

class AddOneChargingStationEvent extends ChargingStationEvent {
  final ChargingStationModel chargingStation;

  AddOneChargingStationEvent(this.chargingStation);
}

class RemoveChargingStationEvent extends ChargingStationEvent {
  final String chargingStationId;

  RemoveChargingStationEvent(this.chargingStationId);
}
