import 'package:bloc/bloc.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUserUseCase registerUserUseCase = RegisterUserUseCase();
  final IsLoggedInUserUseCase isLoggedInUserUseCase = IsLoggedInUserUseCase();
  final LoginUserUseCase loginUserUseCase = LoginUserUseCase();
  final SignInAnonymouslyUseCase signInAnonymouslyUseCase =
      SignInAnonymouslyUseCase();
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase =
      SendPasswordResetEmailUseCase();
  final LogoutUserUseCase logoutUserUseCase = LogoutUserUseCase();

  String? validateEmail(String value) {
    if (value.isEmpty) return 'Email required';
    if (!value.contains('@') && !value.contains('.')) {
      return 'Invalid email';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'Password required';
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateRetypePassword(String password, String retypePassword) {
    if (retypePassword.isEmpty) return 'Please retype password';
    if (password != retypePassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateResetForgotPassword(String email) {
    if (email.isEmpty) return 'Email required';
    if (!email.contains('@') && !email.contains('.')) {
      return 'Invalid email';
    }
    return null;
  }

  AuthBloc() : super(AuthInitialState()) {
    on<ChangeAuthModeEvent>((event, emit) {
      final s = state;
      print('ChangeAuthModeEvent $s');
      if (s is AuthUnauthenticatedState) {
        emit(s.copyWith(isRegisterMode: !s.isRegisterMode));
      } else {
        // Якщо стан не AuthUnauthenticatedState (наприклад, AuthErrorState),
        // все одно переключаємо в потрібний режим
        emit(AuthUnauthenticatedState(isRegisterMode: event.isRegisterMode));
      }
    });

    on<RegisterRequestedEvent>((event, emit) async {
      final s = state;

      if (s is AuthUnauthenticatedState) {
        final emailError = validateEmail(event.email);
        final passwordError = validatePassword(event.password);
        final retypePasswordError = validateRetypePassword(
          event.password,
          event.retypePassword,
        );

        if (emailError != null ||
            passwordError != null ||
            retypePasswordError != null) {
          emit(
            s.copyWith(
              emailError: emailError ?? "",
              passwordError: passwordError ?? "",
              retypePasswordError: retypePasswordError ?? "",
            ),
          );
          return;
        }
      }

      try {
        await registerUserUseCase.execute(
          event.email,
          event.password,
        );

        emit(FirstTimeAuthState());
      } catch (e) {
        print("Auth error: ${e.toString()}");
        emit(AuthErrorState(e.toString()));
      }
    });

    on<IsUserLoggedInAuthEvent>((event, emit) async {
      try {
        final isLoggedIn = await isLoggedInUserUseCase.execute();
        if (isLoggedIn) {
          emit(AuthSuccessState());
        } else {
          emit(AuthUnauthenticatedState(isRegisterMode: false));
        }
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<LoginRequestedEvent>((event, emit) async {
      final s = state;

      if (s is AuthUnauthenticatedState) {
        final emailError = validateEmail(event.email);
        final passwordError = validatePassword(event.password);

        if (emailError != null || passwordError != null) {
          emit(
            s.copyWith(
              emailError: emailError ?? "",
              passwordError: passwordError ?? "",
            ),
          );

          return;
        }

        emit(s.copyWith(isLoading: true));

        try {
          await loginUserUseCase.execute(
            event.email,
            event.password,
          );

          emit(AuthSuccessState());
        } catch (e) {
          final s = state;
          if (s is AuthUnauthenticatedState) {
            add(AuthSnackBarErrorMessageEvent(e.toString()));
            emit(s.copyWith(isLoading: false));
          }
        }
      }
    });

    on<LogoutRequestedEvent>((event, emit) async {
      try {
        await logoutUserUseCase.execute();
        emit(AuthUnauthenticatedState(isRegisterMode: false));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<SignInAnonymouslyEvent>((event, emit) async {
      try {
        await signInAnonymouslyUseCase.execute();
        emit(SignInAnonymouslyState());
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<EmailVerificationEvent>((event, emit) async {
      final s = state;
      if (s is AuthUnauthenticatedState) {
        emit(
          s.copyWith(
            emailError: null,
          ),
        );
      }
    });

    on<PasswordVerificationEvent>((event, emit) async {
      final s = state;

      if (s is AuthUnauthenticatedState) {
        emit(
          s.copyWith(
            passwordError: null,
          ),
        );
      }
    });

    on<RetypePasswordVerificationEvent>((event, emit) {
      final s = state;
      if (s is AuthUnauthenticatedState) {
        emit(
          s.copyWith(
            retypePasswordError: null,
          ),
        );
      }
    });

    on<TogglePasswordVisibilityEvent>((event, emit) {
      final s = state;
      if (s is AuthUnauthenticatedState) {
        final result = s.isPasswordVisible ?? true;
        emit(s.copyWith(isPasswordVisible: !result));
      }
    });

    on<ToggleRetypePasswordVisibilityEvent>((event, emit) {
      final s = state;
      if (s is AuthUnauthenticatedState) {
        final result = s.isRetypePasswordVisible ?? true;
        emit(s.copyWith(isRetypePasswordVisible: !result));
      }
    });

    on<AuthSnackBarErrorMessageEvent>((event, emit) {
      final s = state;
      if (s is AuthUnauthenticatedState) {
        emit(
          s.copyWith(
            errorMessage: event.message.isEmpty ? null : event.message,
          ),
        );
      }
    });

    on<ForgotPasswordEmailVerificationEvent>((event, emit) async {
      final s = state;
      if (s is AuthUnauthenticatedState) {
        final error = validateResetForgotPassword(event.value);

        emit(
          s.copyWith(
            forgotPasswordError: error,
          ),
        );
      }
    });

    on<SendPasswordResetEmailEvent>((event, emit) async {
      try {
        await sendPasswordResetEmailUseCase.execute(event.email);
        emit(AuthUnauthenticatedState(isRegisterMode: false));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });
  }
}
