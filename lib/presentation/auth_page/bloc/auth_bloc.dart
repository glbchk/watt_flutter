import 'package:bloc/bloc.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUserUseCase registerUserUseCase = RegisterUserUseCase();
  final IsLoggedInUserUseCase isLoggedInUserUseCase = IsLoggedInUserUseCase();
  final LoginUserUseCase loginUserUseCase = LoginUserUseCase();
  final LogoutUserUseCase logoutUserUseCase = LogoutUserUseCase();
  final UpdateOnboardingDataUseCase updateOnboardingDateUseCase =
      UpdateOnboardingDataUseCase();
  final SignInAnonymouslyUseCase signInAnonymouslyUseCase =
      SignInAnonymouslyUseCase();

  AuthBloc() : super(AuthInitialState()) {
    on<ChangeAuthModeEvent>((event, emit) {
      final s = state;
      print('ChangeAuthModeEvent $s');
      if (s is AuthUnauthenticatedState) {
        emit(s.copyWith(isRegisterMode: !s.isRegisterMode));
      } else {
        // Якщо стан не AuthUnauthenticatedState (наприклад, AuthErrorState),
        // все одно переключаємо в потрібний режим
        emit(AuthUnauthenticatedState(event.isRegisterMode));
      }
    });

    on<RegisterRequestedEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await registerUserUseCase.execute(
          event.email,
          event.password,
        );
        if (!event.isOnboardingCompleted) {
          emit(FirstTimeAuthState());
        } else {
          emit(AuthSuccessState());
        }
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<IsUserLoggedInAuthEvent>((event, emit) async {
      try {
        final isLoggedIn = await isLoggedInUserUseCase.execute();
        if (isLoggedIn) {
          emit(AuthSuccessState());
        } else {
          emit(AuthUnauthenticatedState(false));
        }
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<LoginRequestedEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await loginUserUseCase.execute(
          event.email,
          event.password,
        );
        emit(AuthSuccessState());
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<LogoutRequestedEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await logoutUserUseCase.execute();
        emit(AuthUnauthenticatedState(false));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<UpdateOnboardingDataEvent>(_updateOnboardingData);

    on<SignInAnonymouslyEvent>(_onSignInAnonymously);

    on<NameVerificationEvent>(_nameVerification);

    on<PhoneNumberVerificationEvent>(_phoneNumberVerification);
  }

  Future<void> _updateOnboardingData(
    UpdateOnboardingDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final userDraft = await updateOnboardingDateUseCase.execute(event.user);
      print(userDraft.id);
      print(userDraft.email);
      print(event.password);
      emit(AuthInProgressState(userDraft, event.password));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onSignInAnonymously(
    SignInAnonymouslyEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await signInAnonymouslyUseCase.execute();
      emit(SignInAnonymouslyState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _nameVerification(
    NameVerificationEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (event.value.isEmpty) {
      emit(NameValidState(null));
      return;
    } else if (event.value.length < 3) {
      emit(NameValidState('Name should be at least 3 symbols'));
      return;
    }

    emit(NameValidState(null));
  }

  Future<void> _phoneNumberVerification(
    PhoneNumberVerificationEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (event.value.isEmpty) {
      emit(PhoneNumberValidState(null));
      return;
    } else if (event.value.length < 11) {
      emit(PhoneNumberValidState('Phone number must contain 9 digits'));
      return;
    }
    emit(PhoneNumberValidState(null));
  }
}
