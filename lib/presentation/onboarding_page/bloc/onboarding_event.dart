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

class OnboardingFilledChargingStationEvent extends OnboardingEvent {
  final ChargingStationModel chargingStation;

  OnboardingFilledChargingStationEvent({
    required this.chargingStation,
  });
}
