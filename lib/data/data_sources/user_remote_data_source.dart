import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/user_model.dart';

class UserRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await firestore.collection('users').doc(user.id).set(user.toJson());
  }

  Future<void> getCurrentUser() async {
    User? user = auth.currentUser;
    await firestore.collection("users").doc(user?.uid).get();
  }

  Future<void> updateUserEmail(String email) async {
    User? user = auth.currentUser;
    await user?.verifyBeforeUpdateEmail(email);
    await firestore.collection("users").doc(user?.uid).update({'email': email});
  }

  Future<void> updateUserName(String name) async {
    User? user = auth.currentUser;
    await user?.updateDisplayName(name);
    await firestore.collection("users").doc(user?.uid).update({'name': name});
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    User? user = auth.currentUser;
    //await user?.updatePhoneNumber(phoneNumber); //Need PhoneAuthCredential
    await firestore.collection("users").doc(user?.uid).update({
      'phone_number': phoneNumber,
    });
  }

  Future<void> addCar(CarModel car) async {
    User? user = auth.currentUser;
    await firestore.collection("users").doc(user?.uid).update({
      'cars': FieldValue.arrayUnion([car.toJson()]),
    });
  }

  Future<UserModel> displayCars() async {
    User? user = auth.currentUser;

    DocumentSnapshot doc = await firestore
        .collection("users")
        .doc(user?.uid)
        .get();

    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> deleteUser() async {
    User? user = auth.currentUser;
    await firestore
        .collection("users")
        .doc(user?.uid)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
    await user?.delete();
  }
}
