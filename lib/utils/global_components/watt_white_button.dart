import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class WattWhiteButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final IconData? icon;
  final Color? textColor;

  const WattWhiteButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading,
    this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: context.theme.appColors.onSecondary.withAlpha(38),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: FilledButton.icon(
        label: Text(
          label,
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
