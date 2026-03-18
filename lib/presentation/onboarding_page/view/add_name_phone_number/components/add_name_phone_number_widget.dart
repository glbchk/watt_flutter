import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class AddNamePhoneNumberWidget extends StatelessWidget {
  final TextEditingController controllerName;
  final TextEditingController controllerPhoneNumber;
  final String? errorName;
  final String? errorPhoneNumber;
  final IconData? nameSuffixIcon;
  final IconData? phoneNumberSuffixIcon;
  final Function(String?) onChangedName;
  final Function(String?) onChangedPhoneNumber;
  final VoidCallback onPressSave;
  final bool isNameValid;
  final bool isPhoneNumberValid;

  const AddNamePhoneNumberWidget({
    super.key,
    required this.controllerName,
    required this.controllerPhoneNumber,
    this.errorName,
    this.errorPhoneNumber,
    this.nameSuffixIcon,
    this.phoneNumberSuffixIcon,
    required this.onChangedName,
    required this.onChangedPhoneNumber,
    required this.onPressSave,
    required this.isNameValid,
    required this.isPhoneNumberValid,
  });

  @override
  Widget build(BuildContext context) {
    final maskFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );

    return Container(
      decoration: BoxDecoration(
        color: context.theme.appColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          top: 20.0,
          right: 20.0,
          bottom: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: controllerName,
              label: 'Name',
              hint: 'e.g. John Doe',
              error: errorName,
              onChanged: onChangedName,
              keyboardType: TextInputType.text,
              suffixIcon: Icon(nameSuffixIcon),
              suffixIconColor: Colors.green,
            ),

            const SizedBox(height: 20.0),
            CustomTextField(
              controller: controllerPhoneNumber,
              label: 'Phone Number',
              hint: 'Start typing here...',
              error: errorPhoneNumber,
              onChanged: onChangedPhoneNumber,
              keyboardType: TextInputType.number,
              suffixIcon: Icon(phoneNumberSuffixIcon),
              suffixIconColor: Colors.green,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
                maskFormatter,
              ],
            ),
            const SizedBox(height: 35.0),
            ((isNameValid) || (isPhoneNumberValid))
                ? WattMainButton(
                    label: 'Save',
                    onPressed: onPressSave,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
