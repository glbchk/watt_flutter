import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class StatusWidget extends StatelessWidget {
  final String? label;

  const StatusWidget({
    super.key,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = context.theme.appColors.success;
    Color textColor = context.theme.appColors.onPrimary;

    if (label == 'Waiting') {
      backgroundColor = context.theme.appColors.primary;
      textColor = context.theme.appColors.onPrimary;
    } else if (label == 'Out of Service') {
      backgroundColor = context.theme.appColors.surface;
      textColor = context.theme.appColors.grey2;
    } else if (label == 'Busy') {
      backgroundColor = context.theme.appColors.warning;
      textColor = context.theme.appColors.onPrimary;
    } else {
      backgroundColor = context.theme.appColors.success;
      textColor = context.theme.appColors.onPrimary;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        child: Text(
          label ?? 'No Status',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
