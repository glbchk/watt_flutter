import 'dart:async';

import 'package:flutter/material.dart';

class TextfieldHelperMethods {
  static void completeTimeFormatting(TextEditingController controller) {
    String text = controller.text;
    if (text.isEmpty) return;

    List<String> parts = text.split(':');
    String hours = parts[0];
    String minutes = parts.length > 1 ? parts[1] : '';

    if (hours.length == 1) {
      hours = '0$hours';
    } else if (hours.isEmpty) {
      hours = '00';
    }

    if (minutes.isEmpty) {
      minutes = '00';
    } else if (minutes.length == 1) {
      minutes = '${minutes}0';
    }

    final formatted = "$hours:$minutes";

    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static void onSearchChanged({
    required String? value,
    required Timer? debounce,
    required Function(String?)? onChanged,
  }) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      onChanged?.call(value);
    });
  }
}
