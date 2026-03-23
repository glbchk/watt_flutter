import 'package:watt/data/repositories/auth_repository_impl.dart';
import 'package:watt/domain/repositories/auth_repository.dart';

abstract class AuthUserUseCase {
  final AuthRepository authRepository = AuthRepositoryImpl();
}

class RegisterUserUseCase extends AuthUserUseCase {
  Future execute(String user, String password) {
    return authRepository.registerUser(user, password);
  }
}

class IsLoggedInUserUseCase extends AuthUserUseCase {
  Future<bool> execute() {
    return authRepository.isUserLoggedIn();
  }
}

class LoginUserUseCase extends AuthUserUseCase {
  Future<String> execute(String email, String password) {
    return authRepository.loginUser(email, password);
  }
}

class SendEmailVerificationUseCase extends AuthUserUseCase {
  Future execute() {
    return authRepository.sendEmailVerification();
  }
}

class SignInAnonymouslyUseCase extends AuthUserUseCase {
  Future<void> execute() {
    return authRepository.signInAnonymously();
  }
}

class SendPasswordResetEmailUseCase extends AuthUserUseCase {
  Future<void> execute(String email) {
    return authRepository.sendPasswordResetEmail(email);
  }
}

class LogoutUserUseCase extends AuthUserUseCase {
  Future<void> execute() {
    return authRepository.logoutUser();
  }
}
