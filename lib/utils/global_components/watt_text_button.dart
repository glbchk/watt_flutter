import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class WattTextButton extends StatelessWidget {
  final VoidCallback callback;
  final String label;
  final bool? withUnderline;
  const WattTextButton({
    super.key,
    required this.callback,
    required this.label,
    this.withUnderline = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: callback,
      child: Text(
        label,

        style: TextStyle(
          fontSize: 15,
          color: context.theme.appColors.primary,
          decoration: withUnderline == true ? TextDecoration.underline : null,
          decorationColor: context.theme.appColors.primary,
        ),
      ),
    );
  }
}
