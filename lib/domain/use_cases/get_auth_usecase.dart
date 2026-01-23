import 'package:watt/data/models/user_model.dart';
import 'package:watt/domain/repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<void> execute(UserModel user, String password) {
    return repository.registerUser(user, password);
  }
}
