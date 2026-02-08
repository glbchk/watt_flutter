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
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;

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
    this.validator,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Timer? debounce;

    void _onSearchChanged(String? value) {
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
          style: TextStyle(fontWeight: FontWeight.bold, color: greyAppColor),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          style: TextStyle(color: Colors.black),
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            errorStyle: TextStyle(
              color: theme.colorScheme.error,
              fontSize: 12,
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(color: hintTextColor),
            errorText: widget.error,
            prefixIcon: widget.prefixIcon != null
                ? IconButton(
                    icon: Icon(
                      widget.prefixIcon,
                      color: widget.prefixIconColor,
                    ),
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
            fillColor: wattColorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderTFColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
