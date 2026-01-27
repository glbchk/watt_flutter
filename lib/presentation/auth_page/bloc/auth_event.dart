abstract class AuthEvent {}

class RegisterRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterRequestedEvent({required this.email, required this.password});
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

// class SwitchToRegisterAuthEvent extends AuthEvent {}

class LogoutRequestedEvent extends AuthEvent {}

//change user

//remove user
