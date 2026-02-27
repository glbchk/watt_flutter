import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/row_toggle.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class CreditCardFormWidget extends StatefulWidget {
  final TextEditingController controllerCardName;
  final TextEditingController controllerCardNumber;
  final TextEditingController controllerExpiry;
  final TextEditingController controllerCvv;
  final String? errorCardName;
  final String? errorCardNumber;
  final String? errorExpiry;
  final String? errorCvv;
  final Widget? cardNumberPrefixIcon;
  final IconData? cardNumberSuffixIcon;
  final IconData? cvvSuffixIcon;
  final Function(String?) onChangedCardName;
  final Function(String?) onChangedCardNumber;
  final Function(String?) onChangedExpiry;
  final Function(String?) onChangedCvv;
  final bool? isSwitched;
  final ValueChanged<bool> onChanged;
  final VoidCallback onPressSave;

  const CreditCardFormWidget({
    super.key,
    required this.controllerCardName,
    required this.controllerCardNumber,
    required this.controllerExpiry,
    required this.controllerCvv,
    this.errorCardName,
    this.errorCardNumber,
    this.errorExpiry,
    this.errorCvv,
    this.cardNumberPrefixIcon,
    this.cardNumberSuffixIcon,
    this.cvvSuffixIcon,
    required this.onChangedCardName,
    required this.onChangedCardNumber,
    required this.onChangedExpiry,
    required this.onChangedCvv,
    this.isSwitched,
    required this.onChanged,
    required this.onPressSave,
  });

  @override
  State<CreditCardFormWidget> createState() => _CreditCardFormWidgetState();
}

class _CreditCardFormWidgetState extends State<CreditCardFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextField(
              controller: widget.controllerCardName,
              label: 'Card Name',
              hint: 'e.g. Default payment method',
              onChanged: widget.onChangedCardName,
              error: widget.errorCardName,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              controller: widget.controllerCardNumber,
              prefixIcon: widget.cardNumberPrefixIcon,
              prefixIconColor: context.theme.appColors.primary,
              suffixIcon: Icons.center_focus_weak,
              suffixIconColor: context.theme.appColors.grey1,
              label: 'Card Number',
              hint: '0000 0000 0000 0000',
              onChanged: (value) {
                setState(() {});
                widget.onChangedCardNumber(value);
              },
              error: widget.errorCardNumber,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                CardNumberFormatter(),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: widget.controllerExpiry,
                    label: 'Expiry',
                    hint: 'MM / YY',
                    onChanged: widget.onChangedExpiry,
                    error: widget.errorExpiry,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      ExpiryDateFormatter(),
                    ],
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: CustomTextField(
                    controller: widget.controllerCvv,
                    isPassword: true,
                    suffixIcon: Icons.visibility,
                    suffixIconColor: context.theme.appColors.grey1,
                    label: 'CVV',
                    hint: '• • •',
                    onChanged: widget.onChangedCvv,
                    error: widget.errorCvv,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            RowToggle(
              label: 'Default payment method',
              isSwitched: widget.isSwitched,
              onChanged: widget.onChanged,
              isLineVisible: false,
            ),
            const SizedBox(height: 40.0),
            WattMainButton(
              label: 'Save',
              onPressed: () {
                widget.onPressSave();
              },
            ),
          ],
        ),
      ),
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
