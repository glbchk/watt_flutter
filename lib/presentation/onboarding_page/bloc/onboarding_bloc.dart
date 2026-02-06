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

  OnboardingBloc() : super(OnboardingState()) {
    on<NameVerificationEvent>((event, emit) {
      if (event.value.length < 3) {
        emit(
          state.copyWith(
            nameError: 'Name should be at least 3 symbols',
            isNameValid: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            name: state.name,
            nameError: null,
            isNameValid: true,
          ),
        );
      }
    });

    on<PhoneNumberVerificationEvent>((event, emit) {
      if (event.value.length < 11) {
        emit(
          state.copyWith(
            phoneNumberError: 'Phone number must contain 9 digits',
            isPhoneNumberValid: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            phoneNumber: state.phoneNumber,
            phoneNumberError: null,
            isPhoneNumberValid: true,
          ),
        );
      }
    });

    on<OnboardingFilledNamePhoneNumberEvent>((event, emit) async {
      await updateUserNameUseCase.execute(
        event.name,
      );
      await updateUserPhoneNumberUseCase.execute(
        event.phoneNumber,
      );
      emit(
        state.copyWith(
          name: event.name,
          phoneNumber: event.phoneNumber,
        ),
      );
    });
  }
}
