import '../models/user_model.dart';

class RemoteDataSource {
  final auth;
  final firestore;

  RemoteDataSource({
    this.auth,
    this.firestore,
  });

  // createUser

  //TO DO: Rebuild and rename to getCurrentUser
  Future<UserModel> fetchUser(String userId) async {
    await Future.delayed(Duration(seconds: 2));
    return UserModel(
      id: userId,
      name: 'John Doe',
      email: '',
      phoneNumber: '',
      language: '',
      paymentMethods: [],
      cars: [],
      chargingStations: [],
    );
  }

  //changeUser

  //removeUser
}
