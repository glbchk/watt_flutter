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

  NameValidState(this.value);
}

class PhoneNumberValidState extends OnboardingState {
  final String? value;

  PhoneNumberValidState(this.value);
}
