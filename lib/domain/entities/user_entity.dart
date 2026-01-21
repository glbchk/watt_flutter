class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String language;
  final List<String> paymentMethods;
  final List<String> cars;
  final List<String> chargingStations;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.language,
    required this.paymentMethods,
    required this.cars,
    required this.chargingStations,
  });
}
