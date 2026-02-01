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
    on<UpdateUserNameEvent>((event, emit) async {
      emit(OnboardingInitialState());
      try {
        await updateUserNameUseCase.execute(
          event.name,
        );
        emit(NameValidState(event.name));
      } catch (e) {
        emit(OnboardingErrorState(e.toString()));
      }
    });

    on<NameVerificationEvent>(_nameVerification);

    on<PhoneNumberVerificationEvent>(_phoneNumberVerification);
  }

  Future<void> _nameVerification(
    NameVerificationEvent event,
    Emitter<OnboardingState> emit,
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
    Emitter<OnboardingState> emit,
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
