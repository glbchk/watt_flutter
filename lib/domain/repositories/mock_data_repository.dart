import 'package:watt/data/models/mock_data_models.dart';

abstract class MockedDataRepository {
  Future<List<MockedCarOption>> getCarOptions();
  Future<List<MockedChargingStationOption>> getChargingStationOptions();
  Future<Map<MockedCarBrand, List<String>>> getCarModelOptions();
  Future<List<String>> getChargingEffectOptions();
  Future<List<String>> getPlugOptions();
}
