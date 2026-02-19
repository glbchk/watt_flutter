import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class HeaderAuth extends StatefulWidget {
  final String title;
  final LinearGradient? backgroundColor;

  const HeaderAuth({
    super.key,
    required this.title,
    this.backgroundColor,
  });

  @override
  State<HeaderAuth> createState() => _HeaderAuthState();
}

class _HeaderAuthState extends State<HeaderAuth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: widget.backgroundColor ?? wattGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 70.0,
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
        ],
      ),
    );
  }
}
