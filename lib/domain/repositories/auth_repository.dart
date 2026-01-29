abstract class AuthRepository {
  Future<void> registerUser(String email, String password);
  Future<String> getCurrentUser();
  Future<String> loginUser(String user, String password);
  Future<bool> isUserLoggedIn();
  Future sendEmailVerification();
  Future<String> signInAnonymously();
  Future<void> logoutUser();
}
