import 'package:watt/data/data_sources/auth_remote_data_source.dart';
import 'package:watt/data/data_sources/user_remote_data_source.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/slot_model.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/domain/entities/user_entity.dart';
import 'package:watt/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();
  final UserRemoteDataSource userRemoteDataSource = UserRemoteDataSource();

  @override
  Future<void> createUser(UserEntity user) async {
    final userModel = UserModel(
      isAnonymous: user.isAnonymous,
      id: user.id,
      name: user.name,
      email: user.email,
      phoneNumber: user.phoneNumber,
      isOnboardingCompleted: user.isOnboardingCompleted,
      // language: user.language,
      paymentMethods: user.paymentMethods,
      cars: user.cars,
      chargingStations: user.chargingStations,
    );

    await userRemoteDataSource.createUser(userModel);
  }

  @override
  Future<void> getCurrentUser() async {
    await userRemoteDataSource.getCurrentUser();
  }

  @override
  Future<void> reauthenticateUser(String password) async {
    await userRemoteDataSource.reauthenticateUser(password);
  }

  @override
  Future<void> updatePhoneNumber(String phoneNumber) async {
    await userRemoteDataSource.updatePhoneNumber(phoneNumber);
  }

  @override
  Future<void> updateUserEmail(String email) async {
    await userRemoteDataSource.updateUserEmail(email);
  }

  @override
  Future<void> updateUserName(String name) async {
    await userRemoteDataSource.updateUserName(name);
  }

  @override
  Future<void> addCar(CarModel car) async {
    await userRemoteDataSource.addCar(car);
  }

  @override
  Future<List<CarModel>> fetchCars() async {
    return await userRemoteDataSource.fetchCars();
  }

  @override
  Future<void> updatePlateNumber(String carId, String plateNumber) async {
    return await userRemoteDataSource.updatePlateNumber(carId, plateNumber);
  }

  @override
  Future<void> deleteCar(String carId) async {
    return await userRemoteDataSource.deleteCar(carId);
  }

  @override
  Future<void> addChargingStations(
    List<ChargingStationModel> chargingStations,
  ) async {
    return await userRemoteDataSource.addStationsToUserData(chargingStations);
  }

  // @override
  // Future<void> syncStationToGlobal() async {
  //   return await userRemoteDataSource.syncStationToGlobal();
  // }

  @override
  Future<void> deleteChargingStation(String stationId) async {
    return await userRemoteDataSource.deleteChargingStation(stationId);
  }

  @override
  Future<List<ChargingStationModel>> fetchChargingStations() async {
    return await userRemoteDataSource.fetchUserChargingStations();
  }

  @override
  Future<void> addPaymentMethod(CreditCardModel creditCard) async {
    return await userRemoteDataSource.addPaymentMethod(creditCard);
  }

  @override
  Future<List<CreditCardModel>> fetchPaymentMethods() async {
    return await userRemoteDataSource.fetchPaymentMethods();
  }

  @override
  Future<void> updateDefaultCreditCard(
    String creditCardId,
    bool isDefault,
  ) async {
    return await userRemoteDataSource.updateDefaultCreditCard(
      creditCardId,
      isDefault,
    );
  }

  @override
  Future<void> removePaymentMethod(String creditCardId) async {
    return await userRemoteDataSource.removePaymentMethod(creditCardId);
  }

  @override
  Future<void> updateDefaultReceivingEarnings(
    String ibanId,
    bool isReceiver,
  ) async {
    return await userRemoteDataSource.updateDefaultReceivingEarnings(
      ibanId,
      isReceiver,
    );
  }

  @override
  Future<UserModel?> fetchUserData() async {
    return await userRemoteDataSource.fetchUserData();
  }

  @override
  Future<ChargingStationModel> fetchOneChargingStation(String stationId) async {
    return await userRemoteDataSource.fetchOneChargingStation(stationId);
  }

  @override
  Future<void> addBooking(BookingModel booking) async {
    return await userRemoteDataSource.addBooking(booking);
  }

  @override
  Future<void> setSlotIsBusy(
    String bookingId,
    List<SlotModel> selectedSlots,
    String cardNumber,
  ) async {
    return await userRemoteDataSource.setSlotIsBusy(
      bookingId,
      selectedSlots,
      cardNumber,
    );
  }

  @override
  Future<void> deleteBooking(BookingModel booking) async {
    return await userRemoteDataSource.deleteBooking(booking);
  }

  @override
  Future<void> deleteUser() async {
    await userRemoteDataSource.deleteUser();
  }
}
