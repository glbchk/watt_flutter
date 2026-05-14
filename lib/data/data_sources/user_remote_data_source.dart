import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/reservation_model.dart';
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

  Future<bool> reauthenticateUser(
    String currentPassword,
    String newEmail,
  ) async {
    User? user = auth.currentUser;

    if (user == null || user.email == null) {
      print('No user found to reauthenticate');
      return false;
    }

    final credential = EmailAuthProvider.credential(
      email: user.email ?? '',
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.verifyBeforeUpdateEmail(newEmail);

    await firestore.collection("users").doc(user.uid).update({
      'email': newEmail,
      'is_email_verified': true,
    });

    return false;
  }

  Future<bool> verifyEmail() async {
    User? user = auth.currentUser;

    if (user == null || user.email == null) {
      print('No user found to reauthenticate');
      return false;
    }

    await user.reload();
    user = auth.currentUser;

    if (user?.emailVerified ?? false) {
      print("Email is verified!");
      await firestore.collection("users").doc(user?.uid).update({
        'is_email_verified': true,
      });
      return true;
    }

    await user?.sendEmailVerification();
    return false;
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

  Future<ReservationModel?> fetchOneUpcomingReservation(
    String stationId,
  ) async {
    User? user = auth.currentUser;
    if (user == null) return null;

    final querySnapshot = await firestore
        .collection("users")
        .doc(user.uid)
        .collection("upcoming_reservations")
        .where("stationId", isEqualTo: stationId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final data = querySnapshot.docs.first.data();

    return ReservationModel.fromJson(data);
  }

  Future<void> confirmUpcomingReservationWithPayment(
    ReservationModel reservation,
    BookingModel booking,
    String cardNumber,
  ) async {
    final user = auth.currentUser;
    if (user == null) return;

    final busySlots = (reservation.selectedTimes ?? [])
        .map((s) => s.copyWith(isBusy: true))
        .toList();

    final confirmedReservation = reservation.copyWith(
      selectedTimes: busySlots,
      cardNumber: cardNumber,
      status: ReservationStatus.confirmed,
    );

    final confirmedBooking = booking.copyWith(
      selectedTimes: busySlots,
      cardNumber: cardNumber,
    );

    await firestore.collection("users").doc(user.uid).update({
      'upcoming_reservations': FieldValue.arrayUnion([
        confirmedReservation.toJson(),
      ]),
    });

    await firestore.collection("users").doc(user.uid).update({
      'upcoming_bookings': FieldValue.arrayUnion([
        confirmedBooking.toJson(),
      ]),
    });

    final stationRef = firestore
        .collection("app_charging_stations")
        .doc(reservation.stationId);

    final busySlotsJson = busySlots.map((s) => s.toJson()).toList();

    await stationRef.set(
      {'slots': FieldValue.arrayUnion(busySlotsJson)},
      SetOptions(merge: true),
    );
  }

  Future<List<ReservationModel>> fetchUpcomingReservations() async {
    User? user = auth.currentUser;
    if (user == null) return [];

    final doc = await firestore.collection("users").doc(user.uid).get();
    final List<dynamic> reservationsJson =
        doc.data()?['upcoming_reservations'] ?? [];

    final upcomingReservations = reservationsJson
        .map(
          (reservation) =>
              ReservationModel.fromJson(reservation as Map<String, dynamic>),
        )
        .toList();

    return upcomingReservations;
  }

  Future<List<ReservationModel>> fetchPastReservations() async {
    User? user = auth.currentUser;
    if (user == null) return [];

    final doc = await firestore.collection("users").doc(user.uid).get();
    final List<dynamic> reservationsJson =
        doc.data()?['past_reservations'] ?? [];

    return reservationsJson
        .map(
          (reservation) =>
              ReservationModel.fromJson(reservation as Map<String, dynamic>),
        )
        .toList();
  }

  Future<ChargingStationModel> fetchOneUpcomingReservedChargingStation(
    String stationId,
  ) async {
    final docRef = await firestore
        .collection("app_charging_stations")
        .doc(stationId)
        .get();
    if (!docRef.exists) {
      throw Exception("Charging station not found in global directory");
    }

    return ChargingStationModel.fromJson(docRef.data() as Map<String, dynamic>);
  }

  Future<void> deleteUpcomingReservation(ReservationModel reservation) async {
    final user = auth.currentUser;
    if (user == null) return;

    final docRef = firestore.collection("users").doc(user.uid);

    await docRef.update({
      'upcoming_reservations': FieldValue.arrayRemove([reservation.toJson()]),
    });

    final stationRef = firestore
        .collection("app_charging_stations")
        .doc(reservation.stationId);

    final stationDoc = await stationRef.get();
    final data = stationDoc.data();

    final List<dynamic> slotsJson = data?['slots'] ?? [];

    final updatedSlots = slotsJson.map((json) {
      final s = SlotModel.fromJson(json);

      final isPartOfReservation =
          reservation.selectedTimes?.any(
            (r) => r.startTime == s.startTime && r.endTime == s.endTime,
          ) ??
          false;

      if (isPartOfReservation) {
        return s.copyWith(isBusy: false).toJson();
      }

      return json;
    }).toList();

    await stationRef.update({
      'slots': updatedSlots,
    });
  }

  Future<List<ChargingStationModel>> fetchAllChargingStations() async {
    final stationsSnapshot = await firestore
        .collection("app_charging_stations")
        .get();

    return stationsSnapshot.docs
        .map((doc) => ChargingStationModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> stopChargingOrCancelReservation(
    ReservationModel reservation,
    BookingModel booking,
  ) async {
    final user = auth.currentUser;
    if (user == null) return;

    final docRef = firestore.collection("users").doc(user.uid);

    await docRef.update({
      'upcoming_reservations': FieldValue.arrayRemove([reservation.toJson()]),
    });

    await firestore.collection("users").doc(user.uid).update({
      'past_reservations': FieldValue.arrayUnion([reservation.toJson()]),
    });

    await docRef.update({
      'upcoming_bookings': FieldValue.arrayRemove([booking.toJson()]),
    });

    await firestore.collection("users").doc(user.uid).update({
      'past_bookings': FieldValue.arrayUnion([booking.toJson()]),
    });
  }

  Future<List<BookingModel>> fetchUpcomingBookings() async {
    User? user = auth.currentUser;
    if (user == null) return [];

    final doc = await firestore.collection("users").doc(user.uid).get();
    final List<dynamic> bookingsJson = doc.data()?['upcoming_bookings'] ?? [];

    return bookingsJson
        .map(
          (booking) => BookingModel.fromJson(booking as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<BookingModel>> fetchPastBookings() async {
    User? user = auth.currentUser;
    if (user == null) return [];

    final doc = await firestore.collection("users").doc(user.uid).get();
    final List<dynamic> bookingsJson = doc.data()?['past_bookings'] ?? [];

    return bookingsJson
        .map(
          (booking) => BookingModel.fromJson(booking as Map<String, dynamic>),
        )
        .toList();
  }

  // Future<void> closeBooking(BookingModel booking) async {
  //   final user = auth.currentUser;
  //   if (user == null) return;
  //
  //   final docRef = firestore.collection("users").doc(user.uid);
  //
  //   await docRef.update({
  //     'upcoming_bookings': FieldValue.arrayRemove([booking.toJson()]),
  //   });
  //
  //   await firestore.collection("users").doc(user.uid).update({
  //     'past_bookings': FieldValue.arrayUnion([booking.toJson()]),
  //   });
  // }

  // Future<void> placeUpcomingBooking(
  //   BookingModel booking,
  //   String stationId,
  // ) async {
  //   final docSnapshot = await firestore
  //       .collection("app_charging_stations")
  //       .doc(stationId)
  //       .get();
  //
  //   final user = auth.currentUser;
  //   if (user == null) return;
  //
  //   if (docSnapshot.exists && docSnapshot.data() != null) {
  //     final station = ChargingStationModel.fromJson(docSnapshot.data()!);
  //
  //     print("Found station: ${station.chargingStationName}");
  //     if (station.id == user.uid) {
  //       await firestore.collection("users").doc(user.uid).update({
  //         'bookings': FieldValue.arrayUnion([booking.toJson()]),
  //       });
  //     }
  //   } else {
  //     print("Station not found!");
  //   }
  // }

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
