import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watt/utils/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? error;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final bool isPassword;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? onChanged;
  final TextCapitalization? textCapitalization;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.error,
    this.suffixIcon,
    this.suffixIconColor,
    this.prefixIcon,
    this.prefixIconColor,
    this.isPassword = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.textCapitalization,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    Timer? debounce;

    void onSearchChanged(String? value) {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        widget.onChanged?.call(value);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.theme.appColors.grey1,
          ),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(color: context.theme.appColors.onSurface),
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            errorStyle: TextStyle(
              color: context.theme.appColors.error,
              fontSize: 12,
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(color: context.theme.appColors.grey2),

            errorText: widget.error,
            prefixIcon: widget.prefixIcon != null
                ? IconButton(
                    icon: Icon(
                      widget.prefixIcon,
                      color: widget.prefixIconColor,
                    ),
                    iconSize: 24,
                    padding: const EdgeInsets.only(right: 10.0, left: 15.0),
                    onPressed: () {},
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      widget.suffixIcon,
                      color: widget.suffixIconColor,
                    ),
                    onPressed: () {},
                  )
                : null,
            filled: true,
            fillColor: context.theme.appColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.theme.appColors.grey3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: context.theme.appColors.primary,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: context.theme.appColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: context.theme.appColors.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
