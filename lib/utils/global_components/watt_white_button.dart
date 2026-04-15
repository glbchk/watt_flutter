import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class WattWhiteButton extends StatelessWidget {
  final String label;
  final double? width;
  final TextScaler? textScaler;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final IconData? icon;
  final Color? textColor;
  final bool noShadow;

  const WattWhiteButton({
    super.key,
    required this.label,
    this.width,
    this.textScaler,
    this.onPressed,
    this.isLoading,
    this.icon,
    this.textColor,
    this.noShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 60,
      decoration: noShadow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: context.theme.appColors.onSecondary.withAlpha(38),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: BoxBorder.all(
                width: 1,
                color: context.theme.appColors.grey3,
              ),
            ),
      child: FilledButton.icon(
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
        style: FilledButton.styleFrom(
          backgroundColor: context.theme.appColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
