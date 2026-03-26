import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/utils/constants.dart';

class MockedDataRemoteDataSource {
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

  Future<List<ChargingStationModel>> getMockedChargingStations() async {
    await Future.delayed(const Duration(seconds: 1));

    return KMockedData.mockedChargingStations;
  }
}
