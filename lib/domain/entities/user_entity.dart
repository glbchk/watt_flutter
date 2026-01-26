class UserEntity {
  final String id;
  final String? name;
  final String email;
  final String? phoneNumber;
  final String? language;
  final List<String>? paymentMethods;
  final List<String>? cars;
  final List<String>? chargingStations;

  UserEntity({
    required this.id,
    this.name,
    required this.email,
    this.phoneNumber,
    this.language,
    this.paymentMethods,
    this.cars,
    this.chargingStations,
  });
}
