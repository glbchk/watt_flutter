class OnboardingState {
  final String? name;
  final String? phoneNumber;
  final String? nameError;
  final String? phoneNumberError;
  final bool isNameValid;
  final bool isPhoneNumberValid;

  OnboardingState({
    this.name,
    this.phoneNumber,
    this.nameError,
    this.phoneNumberError,
    this.isNameValid = false,
    this.isPhoneNumberValid = false,
  });

  OnboardingState copyWith({
    String? name,
    String? phoneNumber,
    String? nameError,
    String? phoneNumberError,
    bool? isNameValid,
    bool? isPhoneNumberValid,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nameError: nameError ?? this.nameError,
      phoneNumberError: phoneNumberError ?? this.phoneNumberError,
      isNameValid: isNameValid ?? this.isNameValid,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
    );
  }
}
