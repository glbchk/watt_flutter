import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class CardButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? frontIcon;
  final Color? iconColor = hintTextColor;
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
        child: Container(
          height: 80.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: wattColorScheme.onSecondary.withAlpha(38),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      color: backgroundColor,
                      child: Icon(
                        frontIcon,
                        color: iconColor,
                      ),
                    ),
                  ),

                  SizedBox(width: 10.0),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: iconColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
