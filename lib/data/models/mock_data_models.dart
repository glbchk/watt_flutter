// enum CarModelEnum {
//   brand = {"Audi"},
//   model = {"Etron"},
// }

enum MockedCarBrand {
  audi,
  bmw,
  tesla,
  volvo,
  chevrolet,
  nissan,
}

class MockedCarOption {
  final String name;
  final String logo;
  final MockedCarBrand brand;
  MockedCarOption(this.name, this.logo, this.brand);
}

class MockedChargingStationOption {
  final String name;
  final String logo;
  MockedChargingStationOption(this.name, this.logo);
}

class MockedCarModel {
  final String model;
  final MockedCarBrand brand;
  MockedCarModel(this.model, this.brand);
}
