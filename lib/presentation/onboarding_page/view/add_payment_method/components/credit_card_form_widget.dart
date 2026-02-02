import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class CreditCardFormWidget extends StatefulWidget {
  final String? errorPlateNumber;
  final VoidCallback? onPressed;

  const CreditCardFormWidget({
    super.key,
    this.errorPlateNumber,
    this.onPressed,
  });

  @override
  State<CreditCardFormWidget> createState() => _CreditCardFormWidgetState();
}

class _CreditCardFormWidgetState extends State<CreditCardFormWidget> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextField(
              controller: TextEditingController(),
              label: 'Card Name',
              hint: 'e.g. Default payment method',
              error: widget.errorPlateNumber,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              controller: TextEditingController(),
              prefixIcon: Icons.credit_card,
              prefixIconColor: wattColorScheme.primary,
              suffixIcon: Icons.center_focus_weak,
              suffixIconColor: greyAppColor,
              label: 'Card Number',
              hint: '0000 0000 0000 0000',
              error: widget.errorPlateNumber,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(),
                    label: 'Expiry',
                    hint: 'MM / YY',
                    error: widget.errorPlateNumber,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(),
                    suffixIcon: Icons.visibility,
                    suffixIconColor: greyAppColor,
                    label: 'CVV',
                    hint: '• • •',
                    error: widget.errorPlateNumber,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Default payment method',
                  style: TextStyle(color: wattBlackColor, fontSize: 15),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 55.0,
                    maxHeight: 30.0,
                  ),
                  child: Switch(
                    value: _isSwitched,
                    thumbColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.grey;
                    }),
                    trackOutlineColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                      return const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 30,
                      );
                    }),
                    trackColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return successColor;
                      }
                      return hintTextColor;
                    }),
                    onChanged: (bool newValue) {
                      setState(() {
                        _isSwitched = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            WattMainButton(
              label: 'Save',
              onPressed: () {
                widget.onPressed;
              },
            ),
          ],
        ),
      ),
    );
  }
}
