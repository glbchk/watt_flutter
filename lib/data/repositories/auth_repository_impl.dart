import 'package:watt/data/data_sources/auth_remote_data_source.dart';
import 'package:watt/data/data_sources/user_remote_data_source.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource, this.userRemoteDataSource);

  @override
  Future<void> registerUser(UserModel user, String password) async {
    final uid = await authRemoteDataSource.register(user.email, password);

    final userWithUid = user.copyUserWith(id: uid);
    await userRemoteDataSource.createUser(userWithUid);
  }
}
