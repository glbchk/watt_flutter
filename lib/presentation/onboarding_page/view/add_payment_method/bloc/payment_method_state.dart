import 'package:watt/data/models/payment_method_model.dart';

class PaymentMethodState {
  final bool isLoading;
  final String? errorMessage;

  final CreditCardModel? creditCard;
  final IbanModel? iban;

  final List<PaymentMethodModel>? paymentMethods;

  final PaymentMethodType? paymentType;
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
    this.paymentType = PaymentMethodType.creditCard,
    this.cardNameError,
    this.cardNumberError,
    this.expiryError,
    this.cvvError,
    this.ibanError,
  });

  PaymentMethodState copyWith({
    bool? isLoading,
    String? errorMessage,
    CreditCardModel? Function()? creditCard,
    IbanModel? Function()? iban,
    List<PaymentMethodModel>? Function()? paymentMethods,
    PaymentMethodType? Function()? paymentType,
    String? Function()? cardNameError,
    String? Function()? cardNumberError,
    String? Function()? expiryError,
    String? Function()? cvvError,
    String? Function()? ibanError,
  }) {
    return PaymentMethodState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      creditCard: creditCard != null ? creditCard() : this.creditCard,
      iban: iban != null ? iban() : this.iban,
      paymentMethods: paymentMethods != null
          ? paymentMethods()
          : this.paymentMethods,
      paymentType: paymentType != null ? paymentType() : this.paymentType,
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
