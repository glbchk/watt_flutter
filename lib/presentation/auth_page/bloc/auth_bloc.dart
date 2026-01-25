import 'package:bloc/bloc.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUserUseCase registerUserUseCase;
  final LoginUserUseCase loginUserUseCase;
  final LogoutUserUseCase logoutUserUseCase;

  AuthBloc({
    required this.registerUserUseCase,
    required this.loginUserUseCase,
    required this.logoutUserUseCase,
  }) : super(AuthInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await registerUserUseCase.execute(
          event.user,
          event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUserUseCase.execute(
          event.email,
          event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await logoutUserUseCase.execute();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
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
