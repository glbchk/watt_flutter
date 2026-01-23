import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watt/data/models/user_model.dart';

class UserRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  UserRemoteDataSource({
    required this.auth,
    required this.firestore,
  });

  Future<void> createUser(UserModel user) async {
    await firestore.collection('users').doc(user.id).set(user.toJson());
  }

  //TODO: Rebuild and rename to getCurrentUser
  Future<UserModel> fetchUser(String userId) async {
    await Future.delayed(Duration(seconds: 2));
    return UserModel(
      id: userId,
      name: 'John Doe',
      email: '',
      phoneNumber: '',
      language: '',
      paymentMethods: [],
      cars: [],
      chargingStations: [],
    );
  }

  //changeUser

  //removeUser
}
