import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class WattMainButton extends StatelessWidget {
  final String label;
  final double? width;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final Icon? icon;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? buttonShadow;

  const WattMainButton({
    super.key,
    required this.label,
    this.width,
    this.onPressed,
    this.isLoading,
    this.icon,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.buttonShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color:
                buttonShadow ?? context.theme.appColors.primary.withAlpha(76),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: FilledButton.icon(
        icon: icon,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor ?? context.theme.appColors.onPrimary,
          ),
        ),
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? context.theme.appColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
