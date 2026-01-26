import 'package:watt/data/repositories/auth_repository_impl.dart';
import 'package:watt/domain/repositories/auth_repository.dart';

abstract class AuthUserUseCase {
  final AuthRepository userRepository = AuthRepositoryImpl();
}

class RegisterUserUseCase extends AuthUserUseCase {
  Future execute(String user, String password) {
    return userRepository.registerUser(user, password);
  }
}

class IsLoggedInUserUseCase extends AuthUserUseCase {
  Future<bool> execute() {
    return userRepository.isUserLoggedIn();
  }
}

class LoginUserUseCase extends AuthUserUseCase {
  Future<String> execute(String email, String password) {
    return userRepository.loginUser(email, password);
  }
}

// class SwitchToRegisterUseCase extends AuthUserUseCase {
//   Future execute() {
//     return userRepository.switchToRegister();
//   }
// }

class LogoutUserUseCase extends AuthUserUseCase {
  Future<void> execute() {
    return userRepository.logoutUser();
  }
}
