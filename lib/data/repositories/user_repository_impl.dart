import 'package:watt/data/data_sources/auth_remote_data_source.dart';
import 'package:watt/data/data_sources/user_remote_data_source.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/reservation_model.dart';
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
  Future<bool> reauthenticateUser(
    String currentPassword,
    String newEmail,
  ) async {
    return await userRemoteDataSource.reauthenticateUser(
      currentPassword,
      newEmail,
    );
  }

  @override
  Future<bool> verifyEmail() async {
    return await userRemoteDataSource.verifyEmail();
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
  Future<ReservationModel?> fetchOneUpcomingReservation(
    String stationId,
  ) async {
    return await userRemoteDataSource.fetchOneUpcomingReservation(stationId);
  }

  @override
  Future<void> confirmUpcomingReservationWithPayment(
    ReservationModel reservationToSave,
    BookingModel bookingToSave,
    String cardNumber,
  ) async {
    return await userRemoteDataSource.confirmUpcomingReservationWithPayment(
      reservationToSave,
      bookingToSave,
      cardNumber,
    );
  }

  @override
  Future<void> deleteUpcomingReservation(ReservationModel booking) async {
    return await userRemoteDataSource.deleteUpcomingReservation(booking);
  }

  @override
  Future<List<ReservationModel>> fetchUpcomingReservations() async {
    return await userRemoteDataSource.fetchUpcomingReservations();
  }

  @override
  Future<List<ChargingStationModel>> fetchAllChargingStations() async {
    return await userRemoteDataSource.fetchAllChargingStations();
  }

  @override
  Future<List<ReservationModel>> fetchPastReservations() async {
    return await userRemoteDataSource.fetchPastReservations();
  }

  @override
  Future<ChargingStationModel> fetchOneUpcomingReservedChargingStation(
    String stationId,
  ) async {
    return await userRemoteDataSource.fetchOneUpcomingReservedChargingStation(
      stationId,
    );
  }

  @override
  Future<void> stopChargingOrCancelReservation(
    ReservationModel reservation,
    BookingModel booking,
  ) async {
    await userRemoteDataSource.stopChargingOrCancelReservation(
      reservation,
      booking,
    );
  }

  @override
  Future<List<BookingModel>> fetchUpcomingBookings() async {
    return await userRemoteDataSource.fetchUpcomingBookings();
  }

  @override
  Future<List<BookingModel>> fetchPastBookings() async {
    return await userRemoteDataSource.fetchPastBookings();
  }

  // @override
  // Future<void> closeBooking(BookingModel booking) async {
  //   await userRemoteDataSource.closeBooking(booking);
  // }

  @override
  Future<void> deleteUser() async {
    await userRemoteDataSource.deleteUser();
  }
}
