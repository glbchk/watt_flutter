import 'package:flutter/material.dart';

class WattTextButton extends StatelessWidget {
  final VoidCallback callback;
  final String label;
  final bool isRegister;
  const WattTextButton({
    super.key,
    required this.callback,
    required this.label,
    required this.isRegister,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: callback,
      child: Text(
        label,
        style: TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
        ),
      ),
    );
  }
}
