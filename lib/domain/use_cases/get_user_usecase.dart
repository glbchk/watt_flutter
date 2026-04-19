import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
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

class ReauthenticateUserUseCase extends UserUseCase {
  Future execute(String password) {
    return userRepository.reauthenticateUser(password);
  }
}

class UpdateUserEmailUseCase extends UserUseCase {
  Future execute(String email) {
    return userRepository.updateUserEmail(email);
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

class AddBookingUseCase extends UserUseCase {
  Future execute(BookingModel booking) {
    return userRepository.addBooking(booking);
  }
}

class UpdateBookingUseCase extends UserUseCase {
  Future execute(String bookingId, BookingStatus status) {
    return userRepository.updateBookingStage(bookingId, status);
  }
}

class DeleteBookingUseCase extends UserUseCase {
  Future execute(String bookingId) {
    return userRepository.deleteBooking(bookingId);
  }
}

class DeleteUserUseCase extends UserUseCase {
  Future execute() {
    return userRepository.deleteUser();
  }
}
