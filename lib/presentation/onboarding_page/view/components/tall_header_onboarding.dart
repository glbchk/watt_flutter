import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class TallHeaderOnboarding extends StatefulWidget {
  final String title;
  final String label;
  final LinearGradient? backgroundColor;

  const TallHeaderOnboarding({
    super.key,
    required this.label,
    required this.title,
    this.backgroundColor,
  });

  @override
  State<TallHeaderOnboarding> createState() => _TallHeaderOnboardingState();
}

class _TallHeaderOnboardingState extends State<TallHeaderOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: widget.backgroundColor ?? wattGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Image.asset(
            logo,
            height: 60.0,
          ),
          const SizedBox(height: 10),
          Text(
            textAlign: TextAlign.center,
            widget.title,
            style: TextStyle(
              color: context.theme.appColors.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            textAlign: TextAlign.center,
            widget.label,
            // softWrap: true,
            style: TextStyle(
              color: context.theme.appColors.onPrimary,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
