import 'package:watt/data/models/user_model.dart';

abstract class AuthRepository {
  Future<void> registerUser(UserModel user, String password);
}
