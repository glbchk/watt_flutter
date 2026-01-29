import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class ShortHeaderOnboarding extends StatefulWidget {
  final String title;
  final String label;
  final LinearGradient backgroundColor = wattGradient;

  const ShortHeaderOnboarding({
    super.key,
    required this.title,
    required this.label,
  });

  @override
  State<ShortHeaderOnboarding> createState() => _ShortHeaderOnboardingState();
}

class _ShortHeaderOnboardingState extends State<ShortHeaderOnboarding> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarHeight = Scaffold.of(context).appBarMaxHeight?.toDouble() ?? 0;
    final heightForTitle = appBarHeight; //+ 40.0;

    return Container(
      // height: heightForTitle,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        top: heightForTitle,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        gradient: widget.backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50.0,
          ),
          Text(
            textAlign: TextAlign.start,
            widget.title,
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            textAlign: TextAlign.start,
            widget.label,
            // softWrap: true,
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
