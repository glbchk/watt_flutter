import 'package:watt/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(UserEntity user);

  Future<UserEntity> getCurrentUser(String userId);

  Future<UserEntity> changeUser(String userId);

  Future<UserEntity> removeUser();

  ///TODO Need to have methods for payment methods, cars, charging stations...
}
