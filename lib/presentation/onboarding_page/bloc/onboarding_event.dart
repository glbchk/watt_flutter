abstract class OnboardingEvent {}

class UpdateUserNameEvent extends OnboardingEvent {
  final String name;

  UpdateUserNameEvent(this.name);
}

class UpdateUserPhoneNumberEvent extends OnboardingEvent {
  final String phoneNumber;

  UpdateUserPhoneNumberEvent(this.phoneNumber);
}

class NameVerificationEvent extends OnboardingEvent {
  final String value;

  NameVerificationEvent({required this.value});
}

class PhoneNumberVerificationEvent extends OnboardingEvent {
  final String value;

  PhoneNumberVerificationEvent({required this.value});
}

class OnboardingSaveEvent extends OnboardingEvent {
  final String name;
  final String phoneNumber;

  OnboardingSaveEvent({required this.name, required this.phoneNumber});
}

class ToggleNamePhoneNumberEvent extends OnboardingEvent {
  final bool isNamePhoneNumberChanged;

  ToggleNamePhoneNumberEvent({required this.isNamePhoneNumberChanged});
}

class DeleteUserEvent extends OnboardingEvent {}
