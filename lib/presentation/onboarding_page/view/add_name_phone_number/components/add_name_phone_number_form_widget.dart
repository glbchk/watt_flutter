import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';

class AddNamePhoneNumberFormWidget extends StatelessWidget {
  final TextEditingController controllerName;
  final TextEditingController controllerPhoneNumber;
  final String? errorName;
  final String? errorPhoneNumber;
  final IconData? nameSuffixIcon;
  final IconData? phoneNumberSuffixIcon;
  final Function(String?) onChangedName;
  final Function(String?) onChangedPhoneNumber;

  const AddNamePhoneNumberFormWidget({
    super.key,
    required this.controllerName,
    required this.controllerPhoneNumber,
    this.errorName,
    this.errorPhoneNumber,
    this.nameSuffixIcon,
    this.phoneNumberSuffixIcon,
    required this.onChangedName,
    required this.onChangedPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );

    return Form(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextField(
              controller: controllerName,
              label: 'Name',
              hint: 'e.g. John Doe',
              error: errorName,
              onChanged: onChangedName,
              keyboardType: TextInputType.text,
              suffixIcon: nameSuffixIcon,
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
              suffixIcon: phoneNumberSuffixIcon,
              suffixIconColor: Colors.green,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
                maskFormatter,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
