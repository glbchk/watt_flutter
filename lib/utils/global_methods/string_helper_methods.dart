import 'package:watt/utils/constants.dart';

class StringHelperMethods {
  static String createNameAndPhoneLabel(String? name, String? phoneNumber) {
    if (name != null && phoneNumber != null) return '$name, $phoneNumber';
    if (name != null) return name;
    if (phoneNumber != null) return phoneNumber;
    return '';
  }

  static String? createChargingStationLabel(
    String? brandName,
    String? chargingEffect,
    String? plug,
  ) {
    if (brandName != null && chargingEffect != null && plug != null) {
      return '$brandName, $chargingEffect, $plug';
    }
    return null;
  }

  static String _formatRange(int start, int end) {
    if (start == end) {
      return KChargingStation.daysList[start] ?? '';
    }

    return '${KChargingStation.daysList[start]}-${KChargingStation.daysList[end]}';
  }

  static String formatDayRanges(List<int>? chosenDays) {
    if (chosenDays == null || chosenDays.isEmpty) {
      return '';
    }

    final sortedDays = List<int>.from(chosenDays)..sort();

    if (sortedDays.isEmpty) return '';

    List<String> groups = [];

    int start = sortedDays.first;
    int last = sortedDays.last;

    groups.add(_formatRange(start, last));

    return groups.join(' - ');
  }

  static String getCardType(String cardNumber) {
    String cleanNumber = cardNumber.replaceAll(' ', '');

    if (cleanNumber.isEmpty) return 'unknown';

    if (cleanNumber.startsWith('4')) return 'visa';

    if (RegExp(r'^5[1-5]').hasMatch(cleanNumber) ||
        RegExp(
          r'^2(22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7[01][0-9]|720)',
        ).hasMatch(cleanNumber)) {
      return 'mastercard';
    }

    if (RegExp(r'^3[47]').hasMatch(cleanNumber)) return 'amex';

    if (cleanNumber.startsWith('65')) return 'discover';

    return 'unknown';
  }

  static String getAssetPath(String cardType) {
    switch (cardType) {
      case 'visa':
        return KPaymentProvidersIcons.visa;
      case 'mastercard':
        return KPaymentProvidersIcons.mastercard;
      case 'amex':
        return KPaymentProvidersIcons.amex;
      case 'discover':
        return KPaymentProvidersIcons.discover;
      default:
        return KPaymentProvidersIcons.generic;
    }
  }
}
