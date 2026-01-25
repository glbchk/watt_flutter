import 'package:watt/domain/entities/user_entity.dart';

abstract class AuthEvent {}

class RegisterRequested extends AuthEvent {
  final UserEntity user;
  final String password;

  RegisterRequested({required this.user, required this.password});
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

class LogoutRequested extends AuthEvent {}

//change user

//remove user
