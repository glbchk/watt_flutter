import 'package:watt/data/data_sources/auth_remote_data_source.dart';
import 'package:watt/data/data_sources/user_remote_data_source.dart';
import 'package:watt/data/models/user_model.dart';
import 'package:watt/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();
  final UserRemoteDataSource userRemoteDataSource = UserRemoteDataSource();

  @override
  Future<void> registerUser(String email, String password) async {
    final uid = await authRemoteDataSource.register(email, password);

    final userWithUid = UserModel(id: uid, email: email);
    await userRemoteDataSource.createUser(userWithUid);
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
  Future<bool> isUserLoggedIn() async {
    return await authRemoteDataSource.getCurrentUser() != null;
  }

  @override
  Future sendEmailVerification() async {
    return await authRemoteDataSource.sendEmailVerification();
  }

  @override
  Future<String> signInAnonymously() async {
    final uid = await authRemoteDataSource.signInAnonymously();

    return uid;
  }

  @override
  Future<void> logoutUser() async {
    await authRemoteDataSource.logout();
  }
}
