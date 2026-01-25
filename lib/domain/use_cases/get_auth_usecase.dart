import 'package:watt/domain/entities/user_entity.dart';
import 'package:watt/domain/repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository userRepository;
  RegisterUserUseCase(this.userRepository);

  Future execute(UserEntity user, String password) {
    return userRepository.registerUser(user, password);
  }
}

class LoginUserUseCase {
  final AuthRepository userRepository;
  LoginUserUseCase(this.userRepository);

  Future<String> execute(String email, String password) {
    return userRepository.loginUser(email, password);
  }
}

class LogoutUserUseCase {
  final AuthRepository userRepository;
  LogoutUserUseCase(this.userRepository);

  Future<void> execute() {
    return userRepository.logoutUser();
  }
}
