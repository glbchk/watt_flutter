import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/slot_model.dart';
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

  Future<void> addStationsToUserData(
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

      final collection = firestore.collection('app_charging_stations');

      final snapshot = await collection.get();
      final existingIds = snapshot.docs.map((doc) => doc.id).toSet();

      final batch = firestore.batch();
      int addedCount = 0;

      for (final station in chargingStations) {
        if (!existingIds.contains(station.id)) {
          batch.set(collection.doc(station.id), station.toJson());
          addedCount++;
        }
      }

      if (addedCount == 0) {
        print('All user stations already in global collection.');
        return;
      }

      await batch.commit();
      print('$addedCount user stations synced to global collection.');
    } catch (e) {
      print("Error syncing collection: $e");
    }
  }

  Future<void> deleteChargingStation(String stationId) async {
    User? user = auth.currentUser;
    final userDocRef = firestore.collection("users").doc(user?.uid);
    final globalDocRef = firestore
        .collection("app_charging_stations")
        .doc(stationId);

    final currentUserData = await userDocRef.get();
    final List<dynamic> chargingStationsData =
        currentUserData.data()?['charging_stations'] ?? [];

    chargingStationsData.removeWhere((station) => station['id'] == stationId);

    final batch = firestore.batch();

    batch.update(userDocRef, {
      'charging_stations': chargingStationsData,
    });

    batch.delete(globalDocRef);

    await batch.commit();
  }

  Future<List<ChargingStationModel>> fetchUserChargingStations() async {
    User? user = auth.currentUser;

    final doc = await firestore.collection("users").doc(user?.uid).get();
    final data = doc.data();
    final List<dynamic> chargingStationsJson = data?['charging_stations'];

    if (chargingStationsJson.isEmpty) return [];

    final globalSnap = await firestore
        .collection("app_charging_stations")
        .get();
    final existingGlobalIds = globalSnap.docs.map((d) => d.id).toSet();

    final batch = firestore.batch();
    int addedCount = 0;

    for (final stationJson in chargingStationsJson) {
      final stationId = stationJson['id'] as String?;
      if (stationId != null && !existingGlobalIds.contains(stationId)) {
        batch.set(
          firestore.collection("app_charging_stations").doc(stationId),
          stationJson as Map<String, dynamic>,
          SetOptions(merge: true),
        );
        addedCount++;
      }
    }

    if (addedCount > 0) {
      await batch.commit();
      print('$addedCount user stations synced to global collection.');
    } else {
      print('All user stations already in global collection.');
    }

    return chargingStationsJson
        .map((s) => ChargingStationModel.fromJson(s as Map<String, dynamic>))
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

  Future<ChargingStationModel> fetchOneChargingStation(String stationId) async {
    User? user = auth.currentUser;

    final doc = await firestore.collection("users").doc(user?.uid).get();
    final data = doc.data();
    final List<dynamic> chargingStationsJson = data?['charging_stations'];

    final station = chargingStationsJson
        .map(
          (json) => ChargingStationModel.fromJson(json as Map<String, dynamic>),
        )
        .firstWhere((item) => item.id == stationId);

    return station;
  }

  Future<BookingModel?> fetchOneBooking(String stationId) async {
    User? user = auth.currentUser;
    if (user == null) return null;

    final querySnapshot = await firestore
        .collection("users")
        .doc(user.uid)
        .collection("bookings")
        .where("stationId", isEqualTo: stationId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final data = querySnapshot.docs.first.data();

    return BookingModel.fromJson(data);
  }

  Future<void> confirmBookingWithPayment(
    BookingModel booking,
    String cardNumber,
  ) async {
    final user = auth.currentUser;
    if (user == null) return;

    final busySlots = (booking.selectedTimes ?? [])
        .map((s) => s.copyWith(isBusy: true))
        .toList();

    final confirmedBooking = booking.copyWith(
      selectedTimes: busySlots,
      cardNumber: cardNumber,
      status: BookingStatus.confirmed,
    );

    await firestore.collection("users").doc(user.uid).update({
      'bookings': FieldValue.arrayUnion([confirmedBooking.toJson()]),
    });

    final stationRef = firestore
        .collection("app_charging_stations")
        .doc(booking.stationId);

    final busySlotsJson = busySlots.map((s) => s.toJson()).toList();

    await stationRef.set(
      {'slots': FieldValue.arrayUnion(busySlotsJson)},
      SetOptions(merge: true),
    );
  }

  Future<List<BookingModel>> fetchBookings() async {
    User? user = auth.currentUser;
    if (user == null) return [];

    final doc = await firestore.collection("users").doc(user.uid).get();
    final List<dynamic> bookingsJson = doc.data()?['bookings'] ?? [];

    return bookingsJson
        .map(
          (booking) => BookingModel.fromJson(booking as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> deleteBooking(BookingModel booking) async {
    final user = auth.currentUser;
    if (user == null) return;

    final docRef = firestore.collection("users").doc(user.uid);

    await docRef.update({
      'bookings': FieldValue.arrayRemove([booking.toJson()]),
    });

    final stationRef = firestore
        .collection("app_charging_stations")
        .doc(booking.stationId);

    final stationDoc = await stationRef.get();
    final data = stationDoc.data();

    final List<dynamic> slotsJson = data?['slots'] ?? [];

    final updatedSlots = slotsJson.map((json) {
      final s = SlotModel.fromJson(json);

      final isPartOfBooking =
          booking.selectedTimes?.any(
            (b) => b.startTime == s.startTime && b.endTime == s.endTime,
          ) ??
          false;

      if (isPartOfBooking) {
        return s.copyWith(isBusy: false).toJson();
      }

      return json;
    }).toList();

    await stationRef.update({
      'slots': updatedSlots,
    });
  }

  Future<List<ChargingStationModel>> fetchBookedChargingStations() async {
    User? user = auth.currentUser;
    if (user == null) return [];

    final userDoc = await firestore.collection("users").doc(user.uid).get();
    final List<dynamic> bookingsJson = userDoc.data()?['bookings'] ?? [];

    final stationIds = bookingsJson
        .map((b) => b['station_id'] as String?)
        .whereType<String>()
        .toSet()
        .toList();

    if (stationIds.isEmpty) return [];

    final stationsSnapshot = await firestore
        .collection("app_charging_stations")
        .where(FieldPath.documentId, whereIn: stationIds)
        .get();

    return stationsSnapshot.docs
        .map((doc) => ChargingStationModel.fromJson(doc.data()))
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
