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

  // Future<void> addChargingStation(ChargingStationModel chargingStation) async {
  //   User? user = auth.currentUser;
  //   await firestore.collection("users").doc(user?.uid).update({
  //     'charging_stations': FieldValue.arrayUnion([chargingStation.toJson()]),
  //   });
  // }

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

  Future<void> addPaymentMethod(PaymentMethodModel paymentMethod) async {
    User? user = auth.currentUser;
    await firestore.collection("users").doc(user?.uid).update({
      'payment_methods': FieldValue.arrayUnion([paymentMethod.toJson()]),
    });
  }

  Future<List<PaymentMethodModel>> fetchPaymentMethods() async {
    User? user = auth.currentUser;

    final doc = await firestore.collection("users").doc(user?.uid).get();
    final data = doc.data();
    final List<dynamic> paymentMethodsJson = data?['payment_methods'] ?? [];

    return paymentMethodsJson
        .map(
          (paymentMethod) => PaymentMethodModel.fromJson(
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
    List<PaymentMethodModel> paymentMethodsList = paymentMethodsData
        .map((json) => PaymentMethodModel.fromJson(json))
        .toList();

    int index = paymentMethodsList.indexWhere(
      (paymentMethod) => paymentMethod.id == creditCardId,
    );

    if (index != -1) {
      if (paymentMethodsList[index] is CreditCardModel) {
        final oldCard = paymentMethodsList[index] as CreditCardModel;

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
  }

  Future<void> updateDefaultReceivingEarnings(
    String ibanId,
    bool isReceiver,
  ) async {
    User? user = auth.currentUser;
    final docRef = firestore.collection("users").doc(user?.uid);

    final currentUserData = await docRef.get();
    List<dynamic> paymentMethodsData =
        currentUserData.data()?['payment_methods'] ?? [];
    List<PaymentMethodModel> paymentMethodsList = paymentMethodsData
        .map((json) => PaymentMethodModel.fromJson(json))
        .toList();

    int index = paymentMethodsList.indexWhere(
      (paymentMethod) => paymentMethod.id == ibanId,
    );

    if (index != -1) {
      if (paymentMethodsList[index] is IbanModel) {
        final oldCard = paymentMethodsList[index] as IbanModel;

        paymentMethodsList[index] = oldCard.copyIbanWith(
          isUsedForReceivingEarnings: isReceiver,
        );

        await docRef.update({
          'payment_methods': paymentMethodsList
              .map((method) => method.toJson())
              .toList(),
        });
      }
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
        .map((json) => BookingModel.fromJson(json))
        .toList();

    int index = bookingsList.indexWhere(
      (booking) => booking.bookingId == bookingId,
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
    User? user = auth.currentUser;
    final docRef = firestore.collection("users").doc(user?.uid);

    final currentUserData = await docRef.get();
    final List<dynamic> bookings = List.from(
      currentUserData.data()?['bookings'] ?? [],
    );

    print('Trying to delete bookingId: "$bookingId"');
    for (final b in bookings) {
      final map = Map<String, dynamic>.from(b);
      print('Firestore booking_id: "${map['booking_id']}"');
    }

    bookings.removeWhere((booking) {
      final map = Map<String, dynamic>.from(booking);
      print('Booking keys: ${map.keys}');
      return map['booking_id'] == bookingId;
    });

    print('Bookings after removeWhere: $bookings');

    await docRef.update({
      'bookings': bookings,
    });
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
