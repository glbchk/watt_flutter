import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watt/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(bool)? onFocusChange;
  final String? label;
  final double? spaceLabel;
  final String? hint;
  final String? error;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final VoidCallback? onSuffixIconTap;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final VoidCallback? onPrefixIconTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final Function(String?)? onChanged;
  final TextCapitalization? textCapitalization;
  final bool? isPassword;
  final bool? showPassword;
  final FormFieldValidator<String>? validator;
  final bool? autofocus;
  final bool? readOnly;
  final String? initialValue;

  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.onFocusChange,
    this.label,
    this.spaceLabel,
    this.hint,
    this.error,
    this.suffixIcon,
    this.suffixIconColor,
    this.onSuffixIconTap,
    this.prefixIcon,
    this.prefixIconColor,
    this.onPrefixIconTap,
    this.isPassword,
    this.showPassword,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onTap,
    this.onChanged,
    this.textCapitalization,
    this.validator,
    this.autofocus,
    this.readOnly = false,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ?label != null
            ? Text(
                label?.toUpperCase() ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.theme.appColors.grey1,
                ),
              )
            : null,
        SizedBox(height: spaceLabel ?? 8.0),
        Focus(
          onFocusChange: onFocusChange,
          canRequestFocus: !(readOnly ?? false),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly ?? false,
            initialValue: initialValue,
            focusNode: focusNode,
            autofocus: autofocus ?? true,
            obscureText: isPassword == true ? !(showPassword ?? false) : false,
            enableSuggestions: isPassword == false,
            autocorrect: isPassword == false,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofillHints: isPassword ?? false
                ? const [AutofillHints.password]
                : null,
            inputFormatters: inputFormatters,
            validator: validator,
            style: TextStyle(color: context.theme.appColors.onSurface),
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            onTapUpOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onTap: onTap,
            onChanged: (String value) => onChanged?.call(value),
            decoration: InputDecoration(
              errorStyle: TextStyle(
                color: context.theme.appColors.error,
                fontSize: 12,
              ),
              hintText: hint,
              hintStyle: TextStyle(color: context.theme.appColors.grey2),
              errorText: (error == null || error!.isEmpty) ? null : error,
              prefixIcon: prefixIcon != null
                  ? GestureDetector(
                      onTap: onPrefixIconTap,
                      child: IconTheme(
                        data: IconThemeData(
                          color:
                              prefixIconColor ??
                              context.theme.appColors.primary,
                          size: 24,
                        ),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(child: prefixIcon!),
                        ),
                      ),
                    )
                  : null,
              suffixIcon: isPassword == true
                  ? IconButton(
                      icon: Icon(
                        showPassword != true
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: onSuffixIconTap,
                    )
                  : suffixIcon,
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
              focusedBorder: readOnly == true
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: context.theme.appColors.grey3,
                      ),
                    )
                  : OutlineInputBorder(
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
        ),
      ],
    );
  }
}
