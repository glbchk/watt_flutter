import 'package:watt/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> saveOnboardingDataForRegister(UserModel user);
  Future<void> registerUser(String email, String password);
  Future<String> getCurrentUser();
  Future<String> loginUser(String user, String password);
  Future<bool> isUserLoggedIn();
  Future sendEmailVerification();
  Future<void> signInAnonymously();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logoutUser();
}
