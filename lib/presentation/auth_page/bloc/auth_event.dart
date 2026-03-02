import 'package:watt/data/models/user_model.dart';

abstract class AuthEvent {}

class RegisterRequestedEvent extends AuthEvent {
  final String email;
  final String password;
  final String retypePassword;
  final bool isOnboardingCompleted;

  RegisterRequestedEvent({
    required this.email,
    required this.password,
    required this.retypePassword,
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

class EmailVerificationEvent extends AuthEvent {
  final String value;

  EmailVerificationEvent({
    required this.value,
  });
}

class PasswordVerificationEvent extends AuthEvent {
  final String value;

  PasswordVerificationEvent({
    required this.value,
  });
}

class RetypePasswordVerificationEvent extends AuthEvent {
  final String value;

  RetypePasswordVerificationEvent({
    required this.value,
  });
}

class AuthSnackBarErrorMessageEvent extends AuthEvent {
  final String message;
  AuthSnackBarErrorMessageEvent(this.message);
}

class ForgotPasswordEmailVerificationEvent extends AuthEvent {
  final String value;

  ForgotPasswordEmailVerificationEvent({
    required this.value,
  });
}

class SendPasswordResetEmailEvent extends AuthEvent {
  final String email;

  SendPasswordResetEmailEvent({
    required this.email,
  });
}
