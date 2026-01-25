import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth auth;

  AuthRemoteDataSource(this.auth);

  Future<String> register(String email, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user!.uid;
  }

  Future<String> getCurrentUser() async {
    User? user = auth.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User is not logged in');
    }
  }

  Future<String> login(String email, String password) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user!.uid;
  }

  Future<void> logout() async {
    return await auth.signOut();
  }
}
