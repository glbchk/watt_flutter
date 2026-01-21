import 'package:watt/data/repositories/user_repository.dart';

import '../../domain/entities/user_entity.dart';
import '../data_sources/remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;

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
  Future<UserEntity> createUser() {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> removeUser() {
    // TODO: implement removeUser
    throw UnimplementedError();
  }
}
