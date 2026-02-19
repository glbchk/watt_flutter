import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class TileSelectorWidget extends StatelessWidget {
  final String? selectedValue;
  final List<String> list;
  final ValueChanged<String> onSelected;
  final IconData? prefixIcon;

  const TileSelectorWidget({
    super.key,
    this.selectedValue,
    required this.list,
    required this.onSelected,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final listValue = list[index];
          final isSelected = selectedValue == listValue;

          return GestureDetector(
            onTap: () => onSelected(listValue),
            child: Container(
              height: 60,
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (prefixIcon != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Icon(
                              prefixIcon,
                              size: 24,
                              color: context.theme.appColors.grey1,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            listValue,
                            style: TextStyle(
                              color: context.theme.appColors.onSurface,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check,
                            color: context.theme.appColors.primary,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: context.theme.appColors.grey3,
                    indent: prefixIcon != null ? 36 : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
