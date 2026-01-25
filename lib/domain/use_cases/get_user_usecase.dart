import 'package:watt/domain/entities/user_entity.dart';
import 'package:watt/domain/repositories/auth_repository.dart';
import 'package:watt/domain/repositories/user_repository.dart';

class CreateUserUseCase {
  final UserRepository userRepository;

  CreateUserUseCase(this.userRepository);

  Future<void> execute(UserEntity user) {
    return userRepository.createUser(user);
  }
}

class GetCurrentUserUseCase {
  final AuthRepository authRepository;

  GetCurrentUserUseCase(this.authRepository);

  Future<String> execute() {
    return authRepository.getCurrentUser();
  }
}

class ChangeUserUseCase {
  final UserRepository userRepository;

  ChangeUserUseCase(this.userRepository);

  Future<UserEntity> execute(String userId) {
    return userRepository.changeUser(userId);
  }
}

class RemoveUserUseCase {
  final UserRepository userRepository;

  RemoveUserUseCase(this.userRepository);

  Future<UserEntity> execute() {
    return userRepository.removeUser();
  }
}
