import '../../domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> createUser();

  Future<UserEntity> getCurrentUser(String userId);

  Future<UserEntity> changeUser(String userId);

  Future<UserEntity> removeUser();

  ///Need to have methods for payment methods, cars, charging stations...
}
