import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class ShortHeaderOnboarding extends StatefulWidget {
  final String mainTitle;
  final String? subtitle;
  final LinearGradient backgroundColor = wattGradient;

  const ShortHeaderOnboarding({
    super.key,
    required this.mainTitle,
    this.subtitle,
  });

  @override
  State<ShortHeaderOnboarding> createState() => _ShortHeaderOnboardingState();
}

class _ShortHeaderOnboardingState extends State<ShortHeaderOnboarding> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mainTitle,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          widget.subtitle != null
              ? Text(
                  widget.subtitle ?? '',
                  style: TextStyle(
                    color: Colors.white,
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
