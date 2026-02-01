import 'package:firebase_auth/firebase_auth.dart';
import 'package:watt/data/models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserModel> saveOnboardingDataForRegister(UserModel user) async {
    return user;
  }

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

  Future sendEmailVerification() async {
    User? user = auth.currentUser;

    await user?.sendEmailVerification();
  }

  Future<String> signInAnonymously() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInAnonymously();
      final String? uid = userCredential.user?.uid;
      print("Signed in with temporary account.");
      return uid ?? 'No Uid';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> logout() async {
    return await auth.signOut();
  }
}
