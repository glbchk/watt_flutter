import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class InlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const InlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        color: context.theme.appColors.background,
        width: double.infinity,
        height: 60,
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 40,
                height: 40,
                color: context.theme.appColors.grey4,
                child: Icon(
                  icon,
                  size: 24,
                  color: context.theme.appColors.primary,
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
                color: context.theme.appColors.onSurface,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
