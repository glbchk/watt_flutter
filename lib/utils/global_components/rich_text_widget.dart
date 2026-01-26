import 'package:flutter/material.dart';

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
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: callback,
          child: Text(
            'Terms & Conditions',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
