import 'package:watt/data/data_sources/auth_remote_data_source.dart';
import 'package:watt/data/data_sources/user_remote_data_source.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/domain/entities/user_entity.dart';
import 'package:watt/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();
  final UserRemoteDataSource userRemoteDataSource = UserRemoteDataSource();

  @override
  Future<void> createUser(UserEntity user) async {
    final userModel = UserModel(
      isAnonymous: user.isAnonymous,
      id: user.id,
      name: user.name,
      email: user.email,
      phoneNumber: user.phoneNumber,
      isOnboardingCompleted: user.isOnboardingCompleted,
      language: user.language,
      paymentMethods: user.paymentMethods,
      cars: user.cars,
      chargingStations: user.chargingStations,
    );

    await userRemoteDataSource.createUser(userModel);
  }

  @override
  Future<void> getCurrentUser() async {
    await userRemoteDataSource.getCurrentUser();
  }

  @override
  Future<void> updatePhoneNumber(String phoneNumber) async {
    await userRemoteDataSource.updatePhoneNumber(phoneNumber);
  }

  @override
  Future<void> updateUserEmail(String email) async {
    await userRemoteDataSource.updateUserEmail(email);
  }

  @override
  Future<void> updateUserName(String name) async {
    await userRemoteDataSource.updateUserName(name);
  }

  @override
  Future<void> deleteUser() async {
    await userRemoteDataSource.deleteUser();
  }
}
