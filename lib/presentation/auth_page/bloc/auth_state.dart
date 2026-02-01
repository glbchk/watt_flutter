import 'package:watt/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class FirstTimeAuthState extends AuthState {}

class SignInAnonymouslyState extends AuthState {}

// default state for page
class AuthUnauthenticatedState extends AuthState {
  final bool isRegisterMode;

  AuthUnauthenticatedState(this.isRegisterMode);

  AuthUnauthenticatedState copyWith({bool? isRegisterMode}) {
    return AuthUnauthenticatedState(
      isRegisterMode ?? this.isRegisterMode,
    );
  }
}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState(this.message);
}

class AuthInProgressState extends AuthState {
  final UserModel userDraft;
  final String password;
  AuthInProgressState(this.userDraft, this.password);
}

class NameValidState extends AuthState {
  final String? value;

  NameValidState(this.value);
}

class PhoneNumberValidState extends AuthState {
  final String? value;

  PhoneNumberValidState(this.value);
}
