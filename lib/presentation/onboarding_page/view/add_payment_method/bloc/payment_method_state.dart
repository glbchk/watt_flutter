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
    CreditCardModel? creditCard,
    IbanModel? iban,
    List<PaymentMethodModel>? paymentMethods,
    PaymentMethodType? paymentType,
    String? cardNameError,
    String? cardNumberError,
    String? expiryError,
    String? cvvError,
    String? ibanError,
  }) {
    return PaymentMethodState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      creditCard: creditCard ?? this.creditCard,
      iban: iban ?? this.iban,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      paymentType: paymentType ?? this.paymentType,
      cardNameError: cardNameError ?? this.cardNameError,
      cardNumberError: cardNumberError ?? this.cardNumberError,
      expiryError: expiryError ?? this.expiryError,
      cvvError: cvvError ?? this.cvvError,
      ibanError: ibanError ?? this.ibanError,
    );
  }
}
