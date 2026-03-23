import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_methods/ui_helper_methods.dart';

class CustomDatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? error;
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePickerField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.error,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UiHelperMethods.pickDate(
        context: context,
        initialDate: initialDate,
        controller: controller,
        onDateSelected: onDateSelected,
      ),
      child: AbsorbPointer(
        // Prevents the keyboard from opening
        child: CustomTextField(
          controller: controller,
          label: label,
          hint: hint,
          error: error,
          suffixIcon: Icon(Icons.calendar_today),
          suffixIconColor: context.theme.appColors.grey1,
        ),
      ),
    );
  }
}
