import 'package:watt/data/data_sources/auth_remote_data_source.dart';
import 'package:watt/data/data_sources/user_remote_data_source.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/domain/entities/user_entity.dart';
import 'package:watt/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource, this.userRemoteDataSource);

  @override
  Future<UserEntity> registerUser(UserEntity user, String password) async {
    final uid = await authRemoteDataSource.register(user.email, password);

    final userWithUid = UserModel.fromEntity(user).copyUserWith(id: uid);
    await userRemoteDataSource.createUser(userWithUid);

    return userWithUid;
  }

  @override
  Future<String> getCurrentUser() async {
    return await authRemoteDataSource.getCurrentUser();
  }

  @override
  Future<String> loginUser(String email, String password) async {
    final uid = await authRemoteDataSource.login(email, password);

    return uid;
  }

  @override
  Future<void> logoutUser() async {
    await authRemoteDataSource.logout();
  }
}
