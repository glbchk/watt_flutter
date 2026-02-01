import 'package:watt/data/models/user_model.dart';

abstract class AuthRepository {
  Future<void> registerUser(String email, String password);
  Future<String> getCurrentUser();
  Future<String> loginUser(String user, String password);
  Future<bool> isUserLoggedIn();
  Future sendEmailVerification();
  Future<void> signInAnonymously();
  Future<void> logoutUser();
  Future<UserModel> saveOnboardingDataForRegister(UserModel user);
}
