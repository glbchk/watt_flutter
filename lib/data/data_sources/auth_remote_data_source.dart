import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> register(String email, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user!.uid;
  }

  Future getCurrentUser() async {
    User? user = auth.currentUser;

    if (user != null) {
      return user;
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

  // Future switchToRegister() async {
  //   isRegisterNotifier.value = !isRegisterNotifier.value;
  // }

  Future<void> logout() async {
    return await auth.signOut();
  }
}
