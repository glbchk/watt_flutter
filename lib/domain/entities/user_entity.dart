import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';

class UserEntity {
  final bool? isAnonymous;
  final String id;
  final String? name;
  final String? email;
  final bool? isEmailVerified;
  final String? phoneNumber;
  final bool isOnboardingCompleted;
  final String? language;
  final List<CarModel>? cars;
  final List<ChargingStationModel>? chargingStations;
  final List<PaymentMethodModel>? paymentMethods;
  final List<BookingModel>? bookings;

  UserEntity({
    this.isAnonymous,
    required this.id,
    this.name,
    this.email,
    this.isEmailVerified,
    this.phoneNumber,
    required this.isOnboardingCompleted,
    this.language,
    this.paymentMethods,
    this.cars,
    this.chargingStations,
    this.bookings,
  });
}
