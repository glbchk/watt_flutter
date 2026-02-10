import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class InlineButton extends StatelessWidget {
  final String label;
  final String? secondLabel;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? textColor;
  final Color? backgroundColor;

  const InlineButton({
    super.key,
    required this.label,
    this.secondLabel,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        color: backgroundColor ?? Colors.transparent,
        width: double.infinity,
        height: 60,
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 40,
                height: 40,
                color: wattColorScheme.surface,
                child: Icon(
                  icon,
                  size: 24,
                  color: wattColorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textColor ?? wattBlackColor,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
