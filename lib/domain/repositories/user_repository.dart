import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/reservation_model.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(UserEntity user);
  Future<void> getCurrentUser();
  Future<void> reauthenticateUser(String password);
  Future<void> updateUserEmail(String email);
  Future<void> updateUserName(String name);
  Future<void> updatePhoneNumber(String phoneNumber);
  Future<void> addCar(CarModel car);
  Future<List<CarModel>> fetchCars();
  Future<void> updatePlateNumber(String carId, String plateNumber);
  Future<void> deleteCar(String carId);
  Future<void> addChargingStations(List<ChargingStationModel> chargingStations);
  Future<void> deleteChargingStation(String stationId);
  Future<List<ChargingStationModel>> fetchChargingStations();
  Future<void> addPaymentMethod(CreditCardModel creditCard);
  Future<List<CreditCardModel>> fetchPaymentMethods();
  Future<void> updateDefaultCreditCard(String creditCardId, bool isDefault);
  Future<void> removePaymentMethod(String creditCardId);
  Future<void> updateDefaultReceivingEarnings(String ibanId, bool isReceiver);
  Future<UserModel?> fetchUserData();
  Future<ChargingStationModel> fetchOneChargingStation(String stationId);
  Future<ReservationModel?> fetchOneUpcomingReservation(String stationId);
  Future<void> confirmUpcomingReservationWithPayment(
    ReservationModel reservationToSave,
    String cardNumber,
  );
  Future<void> deleteUpcomingReservation(ReservationModel booking);
  Future<List<ReservationModel>> fetchUpcomingReservations();
  Future<List<ReservationModel>> fetchPastReservations();
  Future<List<ChargingStationModel>> fetchAllChargingStations();
  Future<ChargingStationModel> fetchOneUpcomingReservedChargingStation(
    String stationId,
  );

  Future<void> stopChargingOrCancelReservation(ReservationModel reservation);
  Future<void> deleteUser();
}
