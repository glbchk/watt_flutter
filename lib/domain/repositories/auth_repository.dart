import 'package:watt/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> registerUser(UserEntity email, String password);
  Future<String> getCurrentUser();
  Future<String> loginUser(String user, String password);
  Future<void> logoutUser();
}
