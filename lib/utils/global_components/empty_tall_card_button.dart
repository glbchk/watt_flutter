import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class EmptyTallCardButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final String label;
  final String? subLabel;
  final double? marginDistance;
  final Color? textColor;
  final Color? backgroundColor;

  const EmptyTallCardButton({
    super.key,
    this.padding,
    required this.label,
    this.subLabel,
    this.marginDistance,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          EdgeInsets.only(
            left: 20.0,
            top: 2.0,
            right: 20.0,
            bottom: 2.0,
          ),
      child: Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: context.theme.appColors.onSecondary.withAlpha(38),
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: context.theme.appColors.background,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      subLabel ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: context.theme.appColors.grey1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
