import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class CardButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? frontIcon;
  final Color? textColor;
  final Color? backgroundColor;

  const CardButton({
    super.key,
    required this.label,
    this.onPressed,
    this.frontIcon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 2.0,
        right: 20.0,
        bottom: 2.0,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          height: 80.0,
          width: double.infinity,
          child: Card(
            color: Colors.white,
            shadowColor: wattColorScheme.onSecondary.withAlpha(100),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      color: Color(0xFFF4F6F9),
                      child: Icon(frontIcon),
                    ),
                  ),

                  SizedBox(width: 10.0),
                  // Icon(Icons.account_circle_outlined),
                  Text(label),
                  Spacer(),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
