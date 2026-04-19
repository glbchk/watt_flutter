import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
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

  Future<void> reauthenticateUser(String password) async {
    User? user = auth.currentUser;
    final email = user?.email;

    if (user == null || email == null) {
      print('No user found to reauthenticate');
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: email ?? '',
      password: password,
    );

    await user?.reauthenticateWithCredential(credential);
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

  Future<void> addChargingStations(
    List<ChargingStationModel> chargingStations,
  ) async {
    User? user = auth.currentUser;
    if (user == null) return;

    List<Map<String, dynamic>> stationsJson = chargingStations
        .map((station) => station.toJson())
        .toList();

    try {
      await firestore.collection("users").doc(user.uid).set({
        'charging_stations': stationsJson,
      }, SetOptions(merge: true));

      print("Full collection synced to Firebase!");
    } catch (e) {
      print("Error syncing collection: $e");
    }
  }

  Future<void> deleteChargingStation(String stationId) async {
    User? user = auth.currentUser;
    final docRef = firestore.collection("users").doc(user?.uid);

    final currentUserData = await docRef.get();
    final List<dynamic> chargingStationsData =
        currentUserData.data()?['charging_stations'] ?? [];

    chargingStationsData.removeWhere((station) => station['id'] == stationId);

    await docRef.update({'charging_stations': chargingStationsData});
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

  Future<void> addPaymentMethod(CreditCardModel paymentMethod) async {
    User? user = auth.currentUser;
    await firestore.collection("users").doc(user?.uid).update({
      'payment_methods': FieldValue.arrayUnion([paymentMethod.toJson()]),
    });
  }

  Future<List<CreditCardModel>> fetchPaymentMethods() async {
    User? user = auth.currentUser;

    final doc = await firestore.collection("users").doc(user?.uid).get();
    final data = doc.data();
    final List<dynamic> paymentMethodsJson = data?['payment_methods'] ?? [];

    return paymentMethodsJson
        .map(
          (paymentMethod) => CreditCardModel.fromJson(
            paymentMethod as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> updateDefaultCreditCard(
    String creditCardId,
    bool isDefault,
  ) async {
    User? user = auth.currentUser;
    final docRef = firestore.collection("users").doc(user?.uid);

    final currentUserData = await docRef.get();
    List<dynamic> paymentMethodsData =
        currentUserData.data()?['payment_methods'] ?? [];
    List<CreditCardModel> paymentMethodsList = paymentMethodsData
        .map((json) => CreditCardModel.fromJson(json))
        .toList();

    int index = paymentMethodsList.indexWhere(
      (paymentMethod) => paymentMethod.id == creditCardId,
    );

    if (index != -1) {
      final oldCard = paymentMethodsList[index];

      paymentMethodsList[index] = oldCard.copyCreditCardWith(
        isDefaultPaymentMethod: isDefault,
      );

      await docRef.update({
        'payment_methods': paymentMethodsList
            .map((method) => method.toJson())
            .toList(),
      });
    }
  }

  Future<void> removePaymentMethod(String creditCardId) async {
    User? user = auth.currentUser;
    final docRef = firestore.collection("users").doc(user?.uid);

    final currentUserData = await docRef.get();
    final List<dynamic> paymentMethodsData =
        currentUserData.data()?['payment_methods'] ?? [];

    paymentMethodsData.removeWhere((station) => station['id'] == creditCardId);

    await docRef.update({'payment_methods': paymentMethodsData});
  }

  Future<void> updateDefaultReceivingEarnings(
    String ibanId,
    bool isReceiver,
  ) async {
    User? user = auth.currentUser;
    final docRef = firestore.collection("users").doc(user?.uid);

    final currentUserData = await docRef.get();
    List<dynamic> paymentMethodsData =
        currentUserData.data()?['bank_accounts'] ?? [];
    List<IbanModel> paymentMethodsList = paymentMethodsData
        .map((json) => IbanModel.fromJson(json))
        .toList();

    int index = paymentMethodsList.indexWhere(
      (paymentMethod) => paymentMethod.id == ibanId,
    );

    if (index != -1) {
      final oldAccount = paymentMethodsList[index];

      paymentMethodsList[index] = oldAccount.copyIbanWith(
        isUsedForReceivingEarnings: isReceiver,
      );

      await docRef.update({
        'payment_methods': paymentMethodsList
            .map((method) => method.toJson())
            .toList(),
      });
    }
  }

  Future<UserModel?> fetchUserData() async {
    User? user = auth.currentUser;
    if (user == null) return null;

    final doc = await firestore.collection("users").doc(user.uid).get();

    if (doc.exists && doc.data() != null) {
      final userModel = UserModel.fromJson(doc.data()!);

      print("DEBUG: Firestore Data: ${doc.data()}");

      return userModel;
    }

    return null;
  }

  Future<void> addBooking(BookingModel booking) async {
    User? user = auth.currentUser;

    await firestore.collection("users").doc(user?.uid).update({
      'bookings': FieldValue.arrayUnion([booking.toJson()]),
    });
  }

  Future<void> updateBookingStage(
    String bookingId,
    BookingStatus status,
  ) async {
    User? user = auth.currentUser;
    final docRef = firestore.collection("users").doc(user?.uid);

    final currentUserData = await docRef.get();
    final List<dynamic> bookingsData =
        currentUserData.data()?['bookings'] ?? [];
    List<BookingModel> bookingsList = bookingsData
        .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
        .toList();

    int index = bookingsList.indexWhere(
      (booking) => booking.id == bookingId,
    );

    if (index != -1) {
      final neededBooking = bookingsList[index];

      bookingsList[index] = neededBooking.copyWith(
        status: status,
      );

      await docRef.update({
        'bookings': bookingsList.map((booking) => booking.toJson()).toList(),
      });
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    // print('Deleting booking $bookingId');
    try {
      User? user = auth.currentUser;
      final docRef = firestore.collection("users").doc(user?.uid);

      // final currentUserData = await docRef.get();
      docRef.get().then(
        (DocumentSnapshot doc) {
          print("DEBUG: Firestore Data: $doc");
          final data = doc.data() as Map<String, dynamic>;
          print("DEBUG: Firestore Data: $data");
        },
        onError: (e) {
          print("Error getting document: $e");
        },
      );
      final List<dynamic> bookingsData = [];
      // currentUserData.data()?['bookings'] ?? [];

      bookingsData.removeWhere((booking) => booking['id'] == bookingId);

      await docRef.update({'bookings': bookingsData});
    } catch (e) {
      print('Error deleting booking: $e');
    }
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
