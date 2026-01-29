import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class BottomFloatingButton extends StatelessWidget {
  final String label;
  final VoidCallback callback;
  const BottomFloatingButton({
    super.key,
    required this.label,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 20.0,
        right: 20.0,
        bottom: 35.0,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60.0,
        child: ElevatedButton(
          onPressed: callback,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
            elevation: 8,
            shadowColor: wattColorScheme.onSecondary.withAlpha(100),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: wattBlackColor,
            ),
          ),
        ),
      ),
    );
  }
}
