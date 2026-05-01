import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/utils/constants.dart';

class MockedDataRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<MockedCarOption>> getCarOptions() async {
    await Future.delayed(const Duration(seconds: 1));

    return KMockedData.cars;
  }

  Future<List<MockedChargingStationOption>> getChargingStationOptions() async {
    await Future.delayed(const Duration(seconds: 1));

    return KMockedData.chargingStations;
  }

  Future<Map<MockedCarBrand, List<String>>> getCarModelOptions() async {
    await Future.delayed(const Duration(seconds: 1));

    return KMockedData.carModels;
  }

  Future<List<String>> getChargingEffectOptions() async {
    await Future.delayed(const Duration(seconds: 1));

    return KMockedData.chargingEffects;
  }

  Future<List<String>> getPlugOptions() async {
    await Future.delayed(const Duration(seconds: 1));

    return KMockedData.plugs;
  }

  Future<void> seedChargingStations(
    List<ChargingStationModel> mockedStations,
  ) async {
    final collection = firestore.collection('app_charging_stations');

    final snapshot = await collection.get();
    final existingIds = snapshot.docs.map((doc) => doc.id).toSet();

    final batch = firestore.batch();
    int addedCount = 0;

    for (final station in mockedStations) {
      if (!existingIds.contains(station.id)) {
        batch.set(collection.doc(station.id), station.toJson());
        addedCount++;
      }
    }

    final user = auth.currentUser;
    if (user != null) {
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final stationsData =
          userDoc.data()?['charging_stations'] as List<dynamic>?;

      if (stationsData != null) {
        for (final stationJson in stationsData) {
          final stationId = stationJson['id'] as String?;
          if (stationId != null && !existingIds.contains(stationId)) {
            batch.set(
              collection.doc(stationId),
              stationJson as Map<String, dynamic>,
              SetOptions(merge: true),
            );
            addedCount++;
          }
        }
      }
    }

    if (addedCount == 0) {
      print('All stations already exist. Nothing to add.');
      return;
    }

    await batch.commit();
    print('$addedCount stations added.');
  }

  Future<Map<String, Set<String>>> getStationIdsForMap() async {
    final user = auth.currentUser;
    if (user == null) return {'user': {}, 'global': {}};

    final userDoc = await firestore.collection('users').doc(user.uid).get();
    final stationsData = userDoc.data()?['charging_stations'] as List<dynamic>?;
    final userIds =
        stationsData
            ?.map((s) => s['id'] as String?)
            .whereType<String>()
            .toSet() ??
        {};

    final globalSnap = await firestore
        .collection('app_charging_stations')
        .get();
    final globalIds = globalSnap.docs.map((d) => d.id).toSet();

    return {'user': userIds, 'global': globalIds};
  }

  // Future<List<ChargingStationModel>>
  // getAddedByUsersMockedChargingStations() async {
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   return KMockedData.mockedAddedByUsersChargingStations;
  // }
  //
  // Future<List<ChargingStationModel>> getPublicMockedChargingStations() async {
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   return KMockedData.mockedPublicChargingStations;
  // }

  Future<List<MockedFaq>> getFaq() async {
    await Future.delayed(const Duration(seconds: 1));

    return KMockedData.faqContent;
  }
}
