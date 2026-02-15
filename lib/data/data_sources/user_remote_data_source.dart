import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
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

  Future<List<CarModel>> fetchCars() async {
    User? user = auth.currentUser;

    final doc = await firestore.collection("users").doc(user?.uid).get();
    final data = doc.data();
    final List<dynamic> carsJson = data?['cars'];

    return carsJson
        .map((car) => CarModel.fromJson(car as Map<String, dynamic>))
        .toList();
  }

  Future<void> updatePlateNumber(String carId, String plateNumber) async {
    User? user = auth.currentUser;
    final docRef = firestore.collection("users").doc(user?.uid);

    final currentUserData = await docRef.get();
    List<dynamic> carsData = currentUserData.data()?['cars'] ?? [];
    List<CarModel> carList = carsData
        .map((json) => CarModel.fromJson(json))
        .toList();

    int index = carList.indexWhere((car) => car.id == carId);

    if (index != -1) {
      carList[index] = carList[index].copyCarWith(plateNumber: plateNumber);
    }
    await docRef.update({
      'cars': carList.map((car) => car.toJson()).toList(),
    });
  }

  Future<void> deleteCar(String carId) async {
    User? user = auth.currentUser;
    final docRef = firestore.collection("users").doc(user?.uid);

    final currentUserData = await docRef.get();
    final List<dynamic> carsData = currentUserData.data()?['cars'] ?? [];

    carsData.removeWhere((car) => car['id'] == carId);

    await docRef.update({'cars': carsData});
  }

  Future<void> addChargingStation(ChargingStationModel chargingStation) async {
    User? user = auth.currentUser;
    await firestore.collection("users").doc(user?.uid).update({
      'charging_stations': FieldValue.arrayUnion([chargingStation.toJson()]),
    });
  }

  Future<List<ChargingStationModel>> fetchChargingStations() async {
    User? user = auth.currentUser;

    final doc = await firestore.collection("users").doc(user?.uid).get();
    final data = doc.data();
    final List<dynamic> chargingStationsJson = data?['charging_stations'];

    return chargingStationsJson
        .map(
          (chargingStation) => ChargingStationModel.fromJson(
            chargingStation as Map<String, dynamic>,
          ),
        )
        .toList();
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
