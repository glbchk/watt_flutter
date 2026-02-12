import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class RowToggle extends StatelessWidget {
  final String label;
  final ValueChanged<bool> onChanged;
  final Color? textColor;
  final bool? isSwitched;

  const RowToggle({
    super.key,
    required this.label,
    required this.onChanged,
    this.textColor,
    this.isSwitched,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderTFColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textColor ?? wattBlackColor,
            ),
          ),
          Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 55.0,
              maxHeight: 30.0,
            ),
            child: Switch(
              value: isSwitched ?? false,
              thumbColor: WidgetStateProperty.resolveWith<Color?>((
                states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.grey;
              }),
              trackOutlineColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
              thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                return const Icon(
                  Icons.circle,
                  color: Colors.white,
                  size: 30,
                );
              }),
              trackColor: WidgetStateProperty.resolveWith<Color?>((
                states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return successColor;
                }
                return hintTextColor;
              }),
              onChanged: onChanged,
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
