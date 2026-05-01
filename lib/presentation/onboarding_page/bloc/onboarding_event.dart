import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';

abstract class OnboardingEvent {}

class NameVerificationEvent extends OnboardingEvent {
  final String value;

  NameVerificationEvent({required this.value});
}

class PhoneNumberVerificationEvent extends OnboardingEvent {
  final String value;

  PhoneNumberVerificationEvent({required this.value});
}

class OnboardingFilledNamePhoneNumberEvent extends OnboardingEvent {
  final String name;
  final String phoneNumber;

  OnboardingFilledNamePhoneNumberEvent({
    required this.name,
    required this.phoneNumber,
  });
}

class OnboardingFilledCarModelEvent extends OnboardingEvent {
  final CarModel car;

  OnboardingFilledCarModelEvent({
    required this.car,
  });
}

class FetchMockedCarOptionsEvent extends OnboardingEvent {}

class FetchMockedCarModelOptionsEvent extends OnboardingEvent {}

class FetchUserCarsEvent extends OnboardingEvent {}

class UpdatePlateNumberCarEvent extends OnboardingEvent {
  final String carId;
  final String plateNumber;

  UpdatePlateNumberCarEvent({
    required this.carId,
    required this.plateNumber,
  });
}

class DeleteCarEvent extends OnboardingEvent {
  final String carId;

  DeleteCarEvent({
    required this.carId,
  });
}

class AddedChargingStationsEvent extends OnboardingEvent {
  final List<ChargingStationModel> chargingStations;
  final String stationId;

  AddedChargingStationsEvent({
    required this.chargingStations,
    required this.stationId,
  });
}

class FetchUserChargingStationsEvent extends OnboardingEvent {}

class FetchUserPaymentMethodsEvent extends OnboardingEvent {}
