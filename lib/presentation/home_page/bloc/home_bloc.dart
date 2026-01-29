// class HomeBloc extends Bloc<AuthEvent, AuthState> {
//   final LogoutUserUseCase logoutUserUseCase = LogoutUserUseCase();

// HomeBloc() : super(AuthInitialState()) {
//   on<LogoutRequestedEvent>((event, emit) async {
//     emit(AuthLoadingState());
//     try {
//       await logoutUserUseCase.execute();
//       emit(AuthUnauthenticatedState());
//     } catch (e) {
//       emit(AuthErrorState(e.toString()));
//     }
//   });
// }
// }
