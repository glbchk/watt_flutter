import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class RichTextWidget extends StatelessWidget {
  final VoidCallback callback;
  const RichTextWidget({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'By creating an account you accept ',
          style: TextStyle(
            color: context.theme.appColors.grey1,
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: callback,
          child: Text(
            'Terms & Conditions',
            style: TextStyle(
              color: context.theme.appColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: context.theme.appColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
