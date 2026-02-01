import 'package:watt/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(UserEntity user);
  Future<void> updateUserEmail(String email);
  Future<void> updateUserName(String name);
  Future<void> updatePhoneNumber(String phoneNumber);
  Future<void> deleteUser();

  ///TODO Need to have methods for payment methods, cars, charging stations...
}
