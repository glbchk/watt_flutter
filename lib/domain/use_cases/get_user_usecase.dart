import '../../data/repositories/user_repository.dart';
import '../entities/user_entity.dart';

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<UserEntity> execute() {
    return repository.createUser();
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
