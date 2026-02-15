import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
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
  Future execute(String email) {
    return userRepository.updateUserEmail(email);
  }
}

class UpdateUserNameUseCase extends UserUseCase {
  Future execute(String name) {
    return userRepository.updateUserName(name);
  }
}

class UpdateUserPhoneNumberUseCase extends UserUseCase {
  Future execute(String phoneNumber) {
    return userRepository.updatePhoneNumber(phoneNumber);
  }
}

class UpdateUserCarUseCase extends UserUseCase {
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

class UpdateUserChargingStationUseCase extends UserUseCase {
  Future execute(ChargingStationModel chargingStation) {
    return userRepository.updateChargingStation(chargingStation);
  }
}

class FetchUserChargingStationsUseCase extends UserUseCase {
  Future execute() {
    return userRepository.fetchChargingStations();
  }
}

class DeleteUserUseCase extends UserUseCase {
  Future execute() {
    return userRepository.deleteUser();
  }
}
