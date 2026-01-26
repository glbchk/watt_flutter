abstract class AuthRepository {
  Future<void> registerUser(String email, String password);
  Future<String> getCurrentUser();
  Future<String> loginUser(String user, String password);
  Future<bool> isUserLoggedIn();
  // Future switchToRegister();
  Future<void> logoutUser();
}
