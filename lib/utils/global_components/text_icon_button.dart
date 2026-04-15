import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class TextIconButton extends StatelessWidget {
  final String label;
  final double? width;
  final TextScaler? textScaler;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final IconData? icon;
  final Color? textColor;

  const TextIconButton({
    super.key,
    required this.label,
    this.width,
    this.textScaler,
    this.onPressed,
    this.isLoading,
    this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: width ?? double.infinity,
      height: 50,
      child: TextButton.icon(
        icon: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            icon ?? Icons.phone,
            size: 24,
            color: context.theme.appColors.onSurface,
          ),
        ),
        label: Text(
          label,
          textScaler: textScaler,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor ?? context.theme.appColors.onSurface,
          ),
        ),
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: context.theme.appColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
