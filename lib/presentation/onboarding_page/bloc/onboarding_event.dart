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

class DeleteUserEvent extends OnboardingEvent {}
