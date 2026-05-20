import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/reservation_model.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/data/repositories/user_repository_impl.dart';
import 'package:watt/domain/entities/user_entity.dart';

abstract class UserUseCase {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();
}

class CreateUserUseCase extends UserUseCase {
  Future<void> execute(UserEntity user) {
    return userRepository.createUser(user);
  }
}

class UpdateUserEmailUseCase extends UserUseCase {
  Future<void> execute(String newEmail) {
    return userRepository.updateEmail(newEmail);
  }
}

// class ListenForEmailVerificationUseCase extends UserUseCase {
//   Stream<bool> execute(String pendingEmail) {
//     return userRepository.listenForEmailVerification(pendingEmail);
//   }
// }

class ReauthenticateUserUseCase extends UserUseCase {
  Future execute(String currentPassword, String newEmail) {
    return userRepository.reauthenticateUser(currentPassword, newEmail);
  }
}

class SendVerificationEmailUserUseCase extends UserUseCase {
  Future execute() {
    return userRepository.sendVerificationEmail();
  }
}

class CheckVerificationEmailAndUpdateUseCase extends UserUseCase {
  Future execute(String pendingEmail) {
    return userRepository.checkVerificationAndUpdate(pendingEmail);
  }
}

class UpdateUserNameUseCase extends UserUseCase {
  Future execute(String name) {
    return userRepository.updateUserName(name);
  }
}

class UpdatePhoneNumberUseCase extends UserUseCase {
  Future execute(String phoneNumber) {
    return userRepository.updatePhoneNumber(phoneNumber);
  }
}

class AddCarUseCase extends UserUseCase {
  Future execute(CarModel car) {
    return userRepository.addCar(car);
  }
}

class FetchUserCarsUseCase extends UserUseCase {
  Future execute() {
    return userRepository.fetchCars();
  }
}

class UpdatePlateNumberCarsUseCase extends UserUseCase {
  Future execute(String carId, String plateNumber) {
    return userRepository.updatePlateNumber(carId, plateNumber);
  }
}

class DeleteCarUseCase extends UserUseCase {
  Future execute(String carId) {
    return userRepository.deleteCar(carId);
  }
}

class AddChargingStationsUseCase extends UserUseCase {
  Future execute(List<ChargingStationModel> chargingStations) {
    return userRepository.addChargingStations(chargingStations);
  }
}

class DeleteChargingStationUseCase extends UserUseCase {
  Future execute(String stationId) {
    return userRepository.deleteChargingStation(stationId);
  }
}

class FetchUserChargingStationsUseCase extends UserUseCase {
  Future execute() {
    return userRepository.fetchChargingStations();
  }
}

class AddPaymentMethodUseCase extends UserUseCase {
  Future execute(CreditCardModel creditCard) {
    return userRepository.addPaymentMethod(creditCard);
  }
}

class FetchPaymentMethodsUseCase extends UserUseCase {
  Future execute() {
    return userRepository.fetchPaymentMethods();
  }
}

class UpdateDefaultCreditCardUseCase extends UserUseCase {
  Future execute(String creditCardId, bool isDefault) {
    return userRepository.updateDefaultCreditCard(creditCardId, isDefault);
  }
}

class RemovePaymentMethodUseCase extends UserUseCase {
  Future execute(String creditCardId) {
    return userRepository.removePaymentMethod(creditCardId);
  }
}

class UpdateDefaultReceivingEarningsUseCase extends UserUseCase {
  Future execute(String ibanId, bool isReceiver) {
    return userRepository.updateDefaultReceivingEarnings(
      ibanId,
      isReceiver,
    );
  }
}

class GetUserDataUseCase extends UserUseCase {
  Future<UserModel?> execute() {
    return userRepository.fetchUserData();
  }
}

class FetchOneChargingStationUseCase extends UserUseCase {
  Future<ChargingStationModel> execute(String stationId) {
    return userRepository.fetchOneChargingStation(stationId);
  }
}

class FetchOneUpcomingReservationUseCase extends UserUseCase {
  Future execute(String stationId) {
    return userRepository.fetchOneUpcomingReservation(stationId);
  }
}

class ConfirmUpcomingReservationWithPaymentUseCase extends UserUseCase {
  Future execute(
    ReservationModel reservationToSave,
    BookingModel bookingToSave,
    String cardNumber,
  ) {
    return userRepository.confirmUpcomingReservationWithPayment(
      reservationToSave,
      bookingToSave,
      cardNumber,
    );
  }
}

class DeleteUpcomingReservationUseCase extends UserUseCase {
  Future execute(ReservationModel reservation) {
    return userRepository.deleteUpcomingReservation(reservation);
  }
}

class FetchUpcomingReservationsUseCase extends UserUseCase {
  Future execute() {
    return userRepository.fetchUpcomingReservations();
  }
}

class FetchPastReservationsUseCase extends UserUseCase {
  Future execute() {
    return userRepository.fetchPastReservations();
  }
}

class FetchAllChargingStationsUseCase extends UserUseCase {
  Future execute() {
    return userRepository.fetchAllChargingStations();
  }
}

class FetchOneUpcomingReservedChargingStationUseCase extends UserUseCase {
  Future<ChargingStationModel> execute(String stationId) {
    return userRepository.fetchOneUpcomingReservedChargingStation(stationId);
  }
}

class StopChargingOrCancelReservationUseCase extends UserUseCase {
  Future execute(ReservationModel reservation, BookingModel booking) {
    return userRepository.stopChargingOrCancelReservation(
      reservation,
      booking,
    );
  }
}

class FetchUpcomingBookingsUseCase extends UserUseCase {
  Future execute() {
    return userRepository.fetchUpcomingBookings();
  }
}

class FetchPastBookingsUseCase extends UserUseCase {
  Future execute() {
    return userRepository.fetchPastBookings();
  }
}

class UpdateChargingStationsOnMapUseCase extends UserUseCase {
  Future execute(List<ChargingStationModel> stations) {
    return userRepository.updateChargingStationsOnMap(stations);
  }
}

class DeleteUserUseCase extends UserUseCase {
  Future execute() {
    return userRepository.deleteUser();
  }
}
