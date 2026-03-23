import 'package:flutter/services.dart';

class PlateNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String cleanText = newValue.text.replaceAll(' ', '').toUpperCase();

    if (cleanText.length > 6) {
      cleanText = cleanText.substring(0, 6);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < cleanText.length; i++) {
      buffer.write(cleanText[i]);

      if (i == 2 && cleanText.length > 3) {
        buffer.write(' ');
      }
    }

    final string = buffer.toString();

    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class TimeSlotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    String hours = '';
    String minutes = '';

    if (digits.length >= 1) {
      hours = digits.substring(0, digits.length >= 2 ? 2 : 1);
    }

    if (digits.length >= 3) {
      minutes = digits.substring(2);
    }

    if (hours.length == 2) {
      int h = int.tryParse(hours) ?? 0;
      if (h > 23) {
        hours = '23';
      }
    }

    if (minutes.length == 2) {
      int m = int.tryParse(minutes) ?? 0;
      if (m > 59) {
        minutes = '59';
      }
    }

    String formatted = hours;

    if (minutes.isNotEmpty) {
      formatted += ':$minutes';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class DoublePriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    if (text.isEmpty) return newValue;

    if (RegExp(r'^\d*\.?\d{0,2}$').hasMatch(text)) {
      return newValue;
    }

    return oldValue;
  }
}

class IbanNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String cleanText = newValue.text.replaceAll(' ', '').toUpperCase();

    if (cleanText.length > 34) {
      cleanText = cleanText.substring(0, 34);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < cleanText.length; i++) {
      String char = cleanText[i];

      if (i < 2) {
        if (!RegExp(r'[A-Z]').hasMatch(char)) return oldValue;
      } else {
        if (!RegExp(r'[0-9]').hasMatch(char)) return oldValue;
      }

      buffer.write(char);

      int index = i + 1;
      if (index % 4 == 0 && index != cleanText.length) {
        buffer.write(' ');
      }
    }

    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var inputText = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();

    for (int i = 0; i < inputText.length; i++) {
      buffer.write(inputText[i]);
      int index = i + 1;

      if (index % 4 == 0 && index != inputText.length) {
        buffer.write(' ');
      }
    }

    var resultText = buffer.toString();

    return TextEditingValue(
      text: resultText,
      selection: TextSelection.collapsed(offset: resultText.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    String month = '';
    String year = '';

    if (digits.isNotEmpty) {
      month = digits.substring(0, digits.length >= 2 ? 2 : 1);
    }

    if (digits.length >= 3) {
      year = digits.substring(2);
    }

    if (month.length == 1) {
      int m = int.parse(month);

      if (m > 1) {
        month = '0$m';
      }
    } else if (month.length == 2) {
      int m = int.parse(month);

      if (m == 0) {
        month = '01';
      } else if (m > 12) {
        month = '12';
      }
    }

    if (year.length == 2) {
      int currentYearShort = DateTime.now().year % 100;
      int enteredYear = int.parse(year);

      if (enteredYear < currentYearShort) {
        year = currentYearShort.toString().padLeft(2, '0');
      }

      if (enteredYear > currentYearShort + 5) {
        final maximumPossibleYear = currentYearShort + 5;
        year = maximumPossibleYear.toString().padLeft(2, '0');
      }
    }

    String formatted = month;

    if (year.isNotEmpty) {
      formatted += ' / $year';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
