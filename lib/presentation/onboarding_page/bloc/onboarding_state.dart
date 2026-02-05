abstract class OnboardingState {}

class OnboardingInitialState extends OnboardingState {}

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

class OnboardingFilledNamePhoneNumberState extends OnboardingState {
  final String? name;
  final String? phoneNumber;
  // final Car? car;
  // final ChargerStation? chargerStation;
  // final PaymentMethod? paymentMethod;

  OnboardingFilledNamePhoneNumberState({
    this.name,
    this.phoneNumber,
  });

  OnboardingFilledNamePhoneNumberState copyWith({
    String? name,
    String? phoneNumber,
    // Car? car,
    // ChargerStation? chargerStation,
    // PaymentMethod? paymentMethod,
  }) {
    return OnboardingFilledNamePhoneNumberState(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      // car: car ?? this.car,
      // chargerStation: chargerStation ?? this.chargerStation,
      // paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

class OnboardingErrorState extends OnboardingState {
  final String message;

  OnboardingErrorState(this.message);
}

// class OnboardingSaveSuccessState extends OnboardingState {}
