import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class WattMainButton extends StatelessWidget {
  final String label;
  final double? width;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final IconData? icon;
  final Color? textColor;

  const WattMainButton({
    super.key,
    required this.label,
    this.width,
    this.onPressed,
    this.isLoading,
    this.icon,
    this.textColor,
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
            color: context.theme.appColors.primary.withAlpha(76),
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
            color: context.theme.appColors.onPrimary,
          ),
        ),
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: context.theme.appColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
