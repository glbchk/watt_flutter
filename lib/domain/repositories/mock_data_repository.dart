import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';

abstract class MockedDataRepository {
  Future<List<MockedCarOption>> getCarOptions();
  Future<List<MockedChargingStationOption>> getChargingStationOptions();
  Future<Map<MockedCarBrand, List<String>>> getCarModelOptions();
  Future<List<String>> getChargingEffectOptions();
  Future<List<String>> getPlugOptions();
  Future<List<ChargingStationModel>> getAddedByUsersMockedChargingStations();
  Future<List<ChargingStationModel>> getPublicMockedChargingStations();
  Future<List<MockedFaq>> getFaq();
}
