import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class DropdownMenuWidget<T> extends StatelessWidget {
  final TextEditingController controller;
  final List<T> listValues;
  final String label;
  final String? subTitle;
  final String? hintText;

  final String Function(T) itemLabel;
  final String Function(T)? itemSubtitle;
  final IconData Function(T)? itemIcon;

  final ValueChanged<T?> onSelected;

  const DropdownMenuWidget({
    super.key,

    required this.controller,
    required this.listValues,
    this.label = 'Select',
    this.subTitle,
    this.hintText = 'Select an option',

    required this.itemLabel,
    this.itemSubtitle,
    this.itemIcon,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - (16.0 * 2);

    return DropdownMenu<T?>(
      controller: controller,
      width: width,
      label: Text(label),
      hintText: hintText,
      requestFocusOnTap: true,
      enableFilter: true,
      onSelected: onSelected,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          Colors.lightBlue.shade50,
        ),
      ),
      dropdownMenuEntries: listValues.map((T value) {
        return DropdownMenuEntry<T>(
          value: value,
          label: itemLabel(value),
          leadingIcon: itemIcon != null
              ? Icon(itemIcon!(value), color: context.theme.appColors.primary)
              : null,
          labelWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                itemLabel(value),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (itemSubtitle != null)
                Text(
                  itemSubtitle!(value),
                  style: TextStyle(
                    fontSize: 12,
                    color: context.theme.appColors.grey1,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
