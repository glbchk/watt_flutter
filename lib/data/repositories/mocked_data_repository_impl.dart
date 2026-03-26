import 'package:watt/data/data_sources/mocked_data_remote_data_source.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/domain/repositories/mock_data_repository.dart';

class MockedDataRepositoryImpl implements MockedDataRepository {
  final MockedDataRemoteDataSource mockDataRemoteDataSource =
      MockedDataRemoteDataSource();

  @override
  Future<List<MockedCarOption>> getCarOptions() async {
    try {
      return await mockDataRemoteDataSource.getCarOptions();
    } catch (e) {
      throw Exception("Failed to fetch mocked cars: $e");
    }
  }

  @override
  Future<List<MockedChargingStationOption>> getChargingStationOptions() async {
    try {
      return await mockDataRemoteDataSource.getChargingStationOptions();
    } catch (e) {
      throw Exception("Failed to fetch mocked charging stations: $e");
    }
  }

  @override
  Future<Map<MockedCarBrand, List<String>>> getCarModelOptions() async {
    try {
      return await mockDataRemoteDataSource.getCarModelOptions();
    } catch (e) {
      throw Exception("Failed to fetch mocked car models: $e");
    }
  }

  @override
  Future<List<String>> getChargingEffectOptions() async {
    try {
      return await mockDataRemoteDataSource.getChargingEffectOptions();
    } catch (e) {
      throw Exception("Failed to fetch mocked charging effects: $e");
    }
  }

  @override
  Future<List<String>> getPlugOptions() async {
    try {
      return await mockDataRemoteDataSource.getPlugOptions();
    } catch (e) {
      throw Exception("Failed to fetch mocked plugs: $e");
    }
  }

  @override
  Future<List<ChargingStationModel>> getMockedChargingStations() async {
    try {
      return await mockDataRemoteDataSource.getMockedChargingStations();
    } catch (e) {
      throw Exception("Failed to fetch mocked charging stations: $e");
    }
  }
}
