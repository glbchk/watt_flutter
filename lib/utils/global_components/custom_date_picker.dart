import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';

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

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      // Apply your Watt theme colors to the picker
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.theme.appColors.primary,
              onPrimary: Colors.white,
              onSurface: context.theme.appColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Format the date for the text field
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: AbsorbPointer(
        // Prevents the keyboard from opening
        child: CustomTextField(
          controller: controller,
          label: label,
          hint: hint,
          error: error,
          suffixIcon: Icons.calendar_today,
          suffixIconColor: context.theme.appColors.grey1,
        ),
      ),
    );
  }
}
