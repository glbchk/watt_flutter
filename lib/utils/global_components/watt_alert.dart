import 'package:flutter/material.dart';

class WattAlert extends StatelessWidget {
  final String title;
  final String? message;
  final String? buttonLabel;
  final VoidCallback? onConfirm;

  const WattAlert({
    super.key,
    required this.title,
    this.message,
    this.buttonLabel,
    this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    String? message,
    String? buttonLabel,
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => WattAlert(
        title: title,
        message: message,
        buttonLabel: buttonLabel,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message ?? ''),
      actions: [
        // TextButton(
        //   onPressed: () => Navigator.pop(context),
        //   child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        // ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            if (onConfirm != null) onConfirm?.call();
          },
          child: Text(buttonLabel ?? ''),
        ),
      ],
    );
  }
}

// class WattAlert {
//   static Future<void> show({
//     required BuildContext context,
//     required String title,
//     required String message,
//     String confirmLabel = 'OK',
//     VoidCallback? onConfirm,
//   }) {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context); // Close the dialog
//               if (onConfirm != null) onConfirm(); // Execute action
//             },
//             child: Text(confirmLabel),
//           ),
//         ],
//       ),
//     );
//   }
// }
