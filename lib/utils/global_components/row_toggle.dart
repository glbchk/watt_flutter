import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class RowToggle extends StatelessWidget {
  final String label;
  final ValueChanged<bool> onChanged;
  final bool? isSwitched;

  const RowToggle({
    super.key,
    required this.label,
    required this.onChanged,
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
            color: context.theme.appColors.grey3,
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
              color: context.theme.appColors.onSurface,
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
                  return context.theme.appColors.background;
                }
                return context.theme.appColors.grey2;
              }),
              trackOutlineColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
              thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                return Icon(
                  Icons.circle,
                  color: context.theme.appColors.background,
                  size: 30,
                );
              }),
              trackColor: WidgetStateProperty.resolveWith<Color?>((
                states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return context.theme.appColors.success;
                }
                return context.theme.appColors.grey2;
              }),
              onChanged: onChanged,
            ),
          ),
          Divider(
            color: context.theme.appColors.grey3,
          ),
        ],
      ),
    );
  }
}
