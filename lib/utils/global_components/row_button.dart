import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class RowButton extends StatelessWidget {
  final String label;
  final String? secondLabel;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final IconData? icon;
  final Color? textColor;
  final Color? backgroundColor;

  const RowButton({
    super.key,
    required this.label,
    this.secondLabel,
    this.onPressed,
    this.isLoading,
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
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: borderTFColor,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textColor ?? wattBlackColor,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                secondLabel ?? '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: textColor ?? greyAppColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: greyAppColor,
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
