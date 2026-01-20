import 'package:flutter/material.dart';

import '../data/colors.dart';

class HeaderWidget extends StatefulWidget {
  // 1. Define the modifiable fields
  final String title;
  final LinearGradient backgroundColor; // Optional parameter

  // 2. Create the constructor
  const HeaderWidget({
    super.key,
    required this.title,
    required this.backgroundColor, // Not required, can be null
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    // 4. Access your custom theme
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Use passed color OR fallback to theme primary
        gradient: widget.backgroundColor,
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
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
