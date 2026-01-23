import 'package:watt/data/data_sources/user_remote_data_source.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/domain/entities/user_entity.dart';
import 'package:watt/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> changeUser(String userId) {
    // TODO: implement changeUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getCurrentUser(String userId) async {
    // final userModel = await remoteDataSource.fetchUser(userId);
    await Future.delayed(const Duration(milliseconds: 600));

    return UserEntity(
      id: '131425',
      name: 'John Doe',
      email: 'peterwatt@amp.com',
      phoneNumber: '+46 73 53 56 999',
      language: 'Ukrainian',
      paymentMethods: [],
      cars: [],
      chargingStations: [],
    );
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

    await remoteDataSource.createUser(userModel);
  }

  @override
  Future<UserEntity> removeUser() {
    // TODO: implement removeUser
    throw UnimplementedError();
  }
}
