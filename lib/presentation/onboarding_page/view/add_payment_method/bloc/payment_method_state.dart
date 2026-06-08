import 'package:watt/data/models/payment_method_model.dart';

class PaymentMethodState {
  final bool isLoading;
  final String? errorMessage;

  final CreditCardModel? creditCard;
  final IbanModel? iban;

  final List<CreditCardModel>? paymentMethods;

  final String? cardNameError;
  final String? cardNumberError;
  final String? expiryError;
  final String? cvvError;
  final String? ibanError;

  PaymentMethodState({
    this.isLoading = false,
    this.errorMessage,
    this.creditCard,
    this.iban,
    this.paymentMethods,
    this.cardNameError,
    this.cardNumberError,
    this.expiryError,
    this.cvvError,
    this.ibanError,
  });

  PaymentMethodState copyWith({
    bool? isLoading,
    String? errorMessage,
    CreditCardModel? creditCard,
    IbanModel? iban,
    List<CreditCardModel>? paymentMethods,
    String? Function()? cardNameError,
    String? Function()? cardNumberError,
    String? Function()? expiryError,
    String? Function()? cvvError,
    String? Function()? ibanError,
  }) {
    return PaymentMethodState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      creditCard: creditCard ?? this.creditCard,
      iban: iban ?? this.iban,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      cardNameError: cardNameError != null
          ? cardNameError()
          : this.cardNameError,
      cardNumberError: cardNumberError != null
          ? cardNumberError()
          : this.cardNumberError,
      expiryError: expiryError != null ? expiryError() : this.expiryError,
      cvvError: cvvError != null ? cvvError() : this.cvvError,
      ibanError: ibanError != null ? ibanError() : this.ibanError,
    );
  }
}
