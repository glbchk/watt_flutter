import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class WattDropdownMenu extends StatelessWidget {
  final String label;
  final String? dropdownValue;
  final String? hintText;
  final String? error;
  final List<String>? listItems;

  final void Function(String?)? onChanged;
  final IconData? icon;

  const WattDropdownMenu({
    super.key,
    required this.label,
    this.dropdownValue,
    this.hintText,
    this.error,
    this.listItems,
    this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.theme.appColors.grey1,
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (error != null && error!.isNotEmpty)
                  ? context.theme.appColors.error
                  : context.theme.appColors.grey3,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              isExpanded: true,
              hint: Text(
                hintText ?? '',
                style: TextStyle(
                  color: context.theme.appColors.grey1,
                ),
              ),
              icon: Icon(
                Icons.unfold_more,
                color: context.theme.appColors.onSurface,
              ),
              dropdownColor: context.theme.appColors.background,
              borderRadius: BorderRadius.circular(12),
              elevation: 6,
              items: listItems?.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: context.theme.appColors.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (error != null && error!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            error!,
            style: TextStyle(
              color: context.theme.appColors.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
