import 'package:watt/data/models/user_model.dart';

abstract class AuthEvent {}

class RegisterRequestedEvent extends AuthEvent {
  final String email;
  final String password;
  final bool isOnboardingCompleted;

  RegisterRequestedEvent({
    required this.email,
    required this.password,
    required this.isOnboardingCompleted,
  });
}

class IsUserLoggedInAuthEvent extends AuthEvent {}

class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  LoginRequestedEvent({required this.email, required this.password});
}

class ChangeAuthModeEvent extends AuthEvent {
  final bool isRegisterMode;

  ChangeAuthModeEvent({required this.isRegisterMode});
}

class LogoutRequestedEvent extends AuthEvent {}

class UpdateOnboardingDataEvent extends AuthEvent {
  final UserModel user;
  final String password;

  UpdateOnboardingDataEvent(this.user, this.password);
}

class SignInAnonymouslyEvent extends AuthEvent {}

class NameVerificationEvent extends AuthEvent {
  final String value;

  NameVerificationEvent({required this.value});
}

class PhoneNumberVerificationEvent extends AuthEvent {
  final String value;

  PhoneNumberVerificationEvent({required this.value});
}

//change user

//remove user
