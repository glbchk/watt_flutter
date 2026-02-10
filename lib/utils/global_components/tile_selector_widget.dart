import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class TileSelectorWidget extends StatelessWidget {
  final String? selectedValue;
  final List<String> list;
  final ValueChanged<String>? onSelected;

  const TileSelectorWidget({
    super.key,
    this.selectedValue,
    required this.list,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final listValue = list[index];
          final isSelected = selectedValue == listValue;

          return Column(
            children: [
              ListTile(
                title: Text(
                  listValue,
                  style: TextStyle(color: wattBlackColor),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () => onSelected?.call(listValue),
              ),
              const Divider(
                height: 1,
                color: borderTFColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
