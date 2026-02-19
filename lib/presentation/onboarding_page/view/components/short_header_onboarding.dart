import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class ShortHeaderOnboarding extends StatefulWidget {
  final String mainTitle;
  final String? subtitle;
  final LinearGradient? backgroundColor;

  const ShortHeaderOnboarding({
    super.key,
    required this.mainTitle,
    this.subtitle,
    this.backgroundColor,
  });

  @override
  State<ShortHeaderOnboarding> createState() => _ShortHeaderOnboardingState();
}

class _ShortHeaderOnboardingState extends State<ShortHeaderOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: widget.backgroundColor ?? wattGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mainTitle,
            style: TextStyle(
              color: context.theme.appColors.background,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          widget.subtitle != null
              ? Text(
                  widget.subtitle ?? '',
                  style: TextStyle(
                    color: context.theme.appColors.background,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
