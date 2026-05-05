import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/repositories/mocked_data_repository_impl.dart';
import 'package:watt/domain/repositories/mock_data_repository.dart';

abstract class MockedDataUseCase {
  final MockedDataRepository mockedDataRepository = MockedDataRepositoryImpl();
}

class FetchMockedCarOptionsUseCase extends MockedDataUseCase {
  Future<List<MockedCarOption>> execute() {
    return mockedDataRepository.getCarOptions();
  }
}

class FetchMockedChargingStationOptionsUseCase extends MockedDataUseCase {
  Future<List<MockedChargingStationOption>> execute() {
    return mockedDataRepository.getChargingStationOptions();
  }
}

class FetchMockedCarModelOptionsUseCase extends MockedDataUseCase {
  Future<Map<MockedCarBrand, List<String>>> execute() {
    return mockedDataRepository.getCarModelOptions();
  }
}

class FetchMockedChargingEffectOptionsUseCase extends MockedDataUseCase {
  Future<List<String>> execute() {
    return mockedDataRepository.getChargingEffectOptions();
  }
}

class FetchMockedPlugOptionsUseCase extends MockedDataUseCase {
  Future<List<String>> execute() {
    return mockedDataRepository.getPlugOptions();
  }
}

class SeedMockedChargingStationsUseCase extends MockedDataUseCase {
  Future<void> execute(List<ChargingStationModel> mockedStations) {
    return mockedDataRepository.seedChargingStations(mockedStations);
  }
}

class GetStationIdsForMapUseCase extends MockedDataUseCase {
  Future<Map<String, Set<String>>> execute() {
    return mockedDataRepository.getStationIdsForMap();
  }
}

class FetchFaqUseCase extends MockedDataUseCase {
  Future<List<MockedFaq>> execute() {
    return mockedDataRepository.getFaq();
  }
}
