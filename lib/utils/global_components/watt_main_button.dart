import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class WattMainButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final IconData? icon;
  final Color? textColor;
  final Color? backgroundColor;

  const WattMainButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: wattColorScheme.primary.withAlpha(76),
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
            color: textColor ?? Colors.white,
          ),
        ),
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
