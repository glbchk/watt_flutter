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

class DeleteUserUseCase extends UserUseCase {
  Future execute() {
    return userRepository.deleteUser();
  }
}
