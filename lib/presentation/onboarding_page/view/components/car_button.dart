import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class CarButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final String carImage;
  final Color? iconColor = hintTextColor;
  final Color? textColor;
  final Color? backgroundColor;

  const CarButton({
    super.key,
    required this.label,
    this.onPressed,
    required this.carImage,
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
          height: 100.0,
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
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(5),
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      color: lightGreyColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          carImage,
                          // fit: BoxFit.contain,
                        ),
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
