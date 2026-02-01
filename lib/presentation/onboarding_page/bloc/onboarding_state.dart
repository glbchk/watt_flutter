abstract class OnboardingState {}

class OnboardingInitialState extends OnboardingState {}

class OnboardingLoadingState extends OnboardingState {}

class OnboardingSuccessState extends OnboardingState {}

class OnboardingErrorState extends OnboardingState {
  final String message;

  OnboardingErrorState(this.message);
}

class NameValidState extends OnboardingState {
  final String? value;
  final bool isNameValid;

  NameValidState(this.value, this.isNameValid);
}

class PhoneNumberValidState extends OnboardingState {
  final String? value;
  final bool isPhoneNumberValid;

  PhoneNumberValidState(this.value, this.isPhoneNumberValid);
}

class ToggleNamePhoneNumberState extends OnboardingState {
  final bool isNamePhoneNumberChanged;

  ToggleNamePhoneNumberState(this.isNamePhoneNumberChanged);

  ToggleNamePhoneNumberState copyWith({bool? isNamePhoneNumberChanged}) {
    return ToggleNamePhoneNumberState(
      isNamePhoneNumberChanged ?? this.isNamePhoneNumberChanged,
    );
  }
}

class OnboardingSaveSuccessState extends OnboardingState {}
