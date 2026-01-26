import 'package:bloc/bloc.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUserUseCase registerUserUseCase = RegisterUserUseCase();
  final IsLoggedInUserUseCase isLoggedInUserUseCase = IsLoggedInUserUseCase();
  final LoginUserUseCase loginUserUseCase = LoginUserUseCase();
  // final SwitchToRegisterUseCase switchToRegisterUseCase =
  //     SwitchToRegisterUseCase();
  final LogoutUserUseCase logoutUserUseCase = LogoutUserUseCase();

  AuthBloc() : super(AuthInitialState()) {
    on<RegisterRequestedEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await registerUserUseCase.execute(
          event.email,
          event.password,
        );
        emit(AuthSuccessState());
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
          emit(AuthUnauthenticatedState());
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

    // on<SwitchToRegisterAuthEvent>((event, emit) async {
    //   emit(AuthLoadingState());
    //   try {
    //     await switchToRegisterUseCase.execute();
    //   } catch (e) {
    //     emit(AuthErrorState(e.toString()));
    //   }
    // });

    on<LogoutRequestedEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await logoutUserUseCase.execute();
        emit(AuthUnauthenticatedState());
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });
  }
}

// @override
// Stream<AuthState> mapEventToState(AuthEvent event) async* {
//   if (event is GetCurrentUserEvent) {
//     yield UserLoading();
//     print('Event received: $event');
//     try {
//       final user = await getCurrentUserUseCase.execute(event.userId);
//       yield UserLoaded(user);
//       print('Event received: $event');
//     } catch (e) {
//       yield UserError("Couldn't fetch user");
//       print('Event received: $event');
//     }
//   }
// }
