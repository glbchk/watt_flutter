import 'package:bloc/bloc.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UpdateUserEmailUseCase updateUserEmailUseCase =
      UpdateUserEmailUseCase();
  final UpdateUserNameUseCase updateUserNameUseCase = UpdateUserNameUseCase();
  final UpdateUserPhoneNumberUseCase updateUserPhoneNumberUseCase =
      UpdateUserPhoneNumberUseCase();

  OnboardingBloc() : super(OnboardingInitialState()) {
    on<NameVerificationEvent>((event, emit) async {
      if (event.value.isEmpty) {
        emit(NameValidState(null, true));
        return;
      } else if (event.value.length < 3) {
        emit(NameValidState('Name should be at least 3 symbols', false));
        return;
      }

      emit(NameValidState(null, true));
    });

    on<PhoneNumberVerificationEvent>((event, emit) async {
      if (event.value.isEmpty) {
        emit(PhoneNumberValidState(null, true));
        return;
      } else if (event.value.length < 11) {
        emit(
          PhoneNumberValidState('Phone number must contain 9 digits', false),
        );
        return;
      }
      emit(PhoneNumberValidState(null, true));
    });

    on<OnboardingFilledNamePhoneNumberEvent>((event, emit) async {
      // emit(OnboardingLoadingState());
      try {
        await updateUserNameUseCase.execute(
          event.name,
        );
        await updateUserPhoneNumberUseCase.execute(
          event.phoneNumber,
        );
        emit(
          OnboardingFilledNamePhoneNumberState(
            name: event.name,
            phoneNumber: event.phoneNumber,
          ),
        );
      } catch (e) {
        emit(OnboardingErrorState(e.toString()));
      }
    });
  }
}
