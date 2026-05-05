class CreditCardModel {
  final String id;
  final String? cardName;
  final String? networkLogo;
  final String? cardNumber;
  final String? expiry;
  final String? cvv;
  final bool isDefaultPaymentMethod;

  CreditCardModel({
    required this.id,
    this.cardName,
    this.networkLogo,
    this.cardNumber,
    this.expiry,
    this.cvv,
    required this.isDefaultPaymentMethod,
  });

  factory CreditCardModel.fromJson(Map<String, dynamic> json) {
    return CreditCardModel(
      id: json['id'],
      cardName: json['card_name'],
      networkLogo: json['network_logo'],
      cardNumber: json['card_number'],
      expiry: json['expiry'],
      cvv: json['cvv'],
      isDefaultPaymentMethod: json['is_default_payment_method'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_name': cardName,
      'network_logo': networkLogo,
      'card_number': cardNumber,
      'expiry': expiry,
      'cvv': cvv,
      'is_default_payment_method': isDefaultPaymentMethod,
    };
  }

  CreditCardModel copyCreditCardWith({
    String? id,
    String? cardName,
    String? networkLogo,
    String? cardNumber,
    String? expiry,
    String? cvv,
    bool? isDefaultPaymentMethod,
  }) {
    return CreditCardModel(
      id: id ?? this.id,
      cardName: cardName ?? this.cardName,
      networkLogo: networkLogo ?? this.networkLogo,
      cardNumber: cardNumber ?? this.cardNumber,
      expiry: expiry ?? this.expiry,
      cvv: cvv ?? this.cvv,
      isDefaultPaymentMethod:
          isDefaultPaymentMethod ?? this.isDefaultPaymentMethod,
    );
  }
}

class IbanModel {
  final String id;
  final String? ibanNumber;
  final bool isUsedForReceivingEarnings;

  IbanModel({
    required this.id,
    this.ibanNumber,
    required this.isUsedForReceivingEarnings,
  });

  factory IbanModel.fromJson(Map<String, dynamic> json) {
    return IbanModel(
      id: json['id'],
      ibanNumber: json['iban'],
      isUsedForReceivingEarnings:
          json['is_used_for_receiving_earnings'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'iban': ibanNumber,
      'is_used_for_receiving_earnings': isUsedForReceivingEarnings,
    };
  }

  IbanModel copyIbanWith({
    String? id,
    String? ibanNumber,
    bool? isUsedForReceivingEarnings,
  }) {
    return IbanModel(
      id: id ?? this.id,
      ibanNumber: ibanNumber ?? this.ibanNumber,
      isUsedForReceivingEarnings:
          isUsedForReceivingEarnings ?? this.isUsedForReceivingEarnings,
    );
  }
}
