import 'package:watt/domain/entities/user_entity.dart';
import 'package:watt/domain/repositories/user_repository.dart';

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<void> execute(UserEntity user) {
    return repository.createUser(user);
  }
}

class GetCurrentUserUseCase {
  final UserRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserEntity> execute(String userId) {
    return repository.getCurrentUser(userId);
  }
}

class ChangeUserUseCase {
  final UserRepository repository;

  ChangeUserUseCase(this.repository);

  Future<UserEntity> execute(String userId) {
    return repository.changeUser(userId);
  }
}

class RemoveUserUseCase {
  final UserRepository repository;

  RemoveUserUseCase(this.repository);

  Future<UserEntity> execute() {
    return repository.removeUser();
  }
}
