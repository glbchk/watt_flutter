import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watt/utils/colors.dart';

class SmallTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? error;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? onChanged;
  final TextCapitalization? textCapitalization;
  final bool? autofocus;

  const SmallTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.error,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.textCapitalization,
    this.autofocus,
  });

  @override
  State<SmallTextField> createState() => _SmallTextFieldState();
}

class _SmallTextFieldState extends State<SmallTextField> {
  Timer? debounce;
  @override
  Widget build(BuildContext context) {
    void onSearchChanged(String? value) {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        widget.onChanged?.call(value);
      });
    }

    return SizedBox(
      width: 64.0,
      height: 28.0,
      child: TextField(
        controller: widget.controller,
        autofocus: widget.autofocus ?? true,
        enableSuggestions: false,
        autocorrect: false,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        style: TextStyle(color: context.theme.appColors.onSurface),
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        onChanged: onSearchChanged,
        // textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          errorStyle: TextStyle(
            color: context.theme.appColors.error,
            fontSize: 12,
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: context.theme.appColors.grey2,
          ),
          filled: true,
          fillColor: context.theme.appColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: context.theme.appColors.grey3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: context.theme.appColors.primary,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
