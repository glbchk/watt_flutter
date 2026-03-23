import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/row_toggle.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_methods/custom_input_formatters.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class CreditCardFormWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    String cardType = StringHelperMethods.getCardType(
      controllerCardNumber.text,
    );

    return Form(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextField(
              controller: controllerCardName,
              label: 'Card Name',
              hint: 'e.g. Default payment method',
              onChanged: onChangedCardName,
              error: errorCardName,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              controller: controllerCardNumber,
              prefixIcon: cardNumberPrefixIcon,
              prefixIconColor: context.theme.appColors.primary,
              suffixIcon: Icon(Icons.center_focus_weak),
              suffixIconColor: context.theme.appColors.grey1,
              label: 'Card Number',
              hint: '0000 0000 0000 0000',
              onChanged: onChangedCardNumber,
              error: errorCardNumber,
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
                    controller: controllerExpiry,
                    label: 'Expiry',
                    hint: 'MM / YY',
                    onChanged: onChangedExpiry,
                    error: errorExpiry,
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
                    controller: controllerCvv,
                    isPassword: true,
                    suffixIcon: Icon(Icons.visibility),
                    suffixIconColor: context.theme.appColors.grey1,
                    label: 'CVV',
                    hint: cardType == 'amex' ? '• • • •' : '• • •',
                    onChanged: onChangedCvv,
                    error: errorCvv,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                        cardType == 'amex' ? 4 : 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            RowToggle(
              label: 'Default payment method',
              isSwitched: isSwitched,
              onChanged: onChanged,
              isLineVisible: false,
            ),
            const SizedBox(height: 40.0),
            WattMainButton(
              label: 'Save',
              onPressed: () {
                onPressSave();
              },
            ),
          ],
        ),
      ),
    );
  }
}
