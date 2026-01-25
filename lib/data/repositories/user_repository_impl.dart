import 'package:watt/data/data_sources/auth_remote_data_source.dart';
import 'package:watt/data/data_sources/user_remote_data_source.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/domain/entities/user_entity.dart';
import 'package:watt/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  final AuthRemoteDataSource authRemoteDataSource;

  UserRepositoryImpl(this.userRemoteDataSource, this.authRemoteDataSource);

  @override
  Future<UserEntity> changeUser(String userId) {
    // TODO: implement changeUser
    throw UnimplementedError();
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phoneNumber: user.phoneNumber,
      language: user.language,
      paymentMethods: user.paymentMethods,
      cars: user.cars,
      chargingStations: user.chargingStations,
    );

    await userRemoteDataSource.createUser(userModel);
  }

  @override
  Future<UserEntity> removeUser() {
    // TODO: implement removeUser
    throw UnimplementedError();
  }
}
