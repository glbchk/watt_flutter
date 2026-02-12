import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(UserEntity user);
  Future<void> getCurrentUser();
  Future<void> updateUserEmail(String email);
  Future<void> updateUserName(String name);
  Future<void> updatePhoneNumber(String phoneNumber);
  Future<void> addCar(CarModel car);
  Future<UserModel> displayCars();
  Future<void> addChargingStation(ChargingStationModel chargingStation);
  Future<void> deleteUser();

  ///TODO Need to have methods for payment methods, cars, charging stations...
}
