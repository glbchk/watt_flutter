import 'package:watt/data/models/payment_method_model.dart';

abstract class PaymentMethodEvent {}

class CardNameVerificationEvent extends PaymentMethodEvent {
  final String value;

  CardNameVerificationEvent({required this.value});
}

class CardNumberVerificationEvent extends PaymentMethodEvent {
  final String value;

  CardNumberVerificationEvent({required this.value});
}

class ExpiryVerificationEvent extends PaymentMethodEvent {
  final String value;

  ExpiryVerificationEvent({required this.value});
}

class CvvVerificationEvent extends PaymentMethodEvent {
  final String value;

  CvvVerificationEvent({required this.value});
}

class FilledCreditCardEvent extends PaymentMethodEvent {
  final CreditCardModel card;

  FilledCreditCardEvent({
    required this.card,
  });
}

class FilledIbanEvent extends PaymentMethodEvent {
  final IbanModel iban;

  FilledIbanEvent({
    required this.iban,
  });
}

class FetchPaymentMethodsEvent extends PaymentMethodEvent {}

class UpdateDefaultCreditCardEvent extends PaymentMethodEvent {
  final String creditCardId;
  final bool isDefault;

  UpdateDefaultCreditCardEvent({
    required this.creditCardId,
    required this.isDefault,
  });
}

class UpdateDefaultReceivingEarningsEvent extends PaymentMethodEvent {
  final String ibanId;
  final bool isReceiver;

  UpdateDefaultReceivingEarningsEvent({
    required this.ibanId,
    required this.isReceiver,
  });
}
