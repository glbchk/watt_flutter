import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';

class SelectCarModelFormWidget extends StatefulWidget {
  final String? selectedValue;
  final List<String> listItems;
  final ValueChanged<String?>? onDropdownChanged;
  final String? errorPlateNumber;

  const SelectCarModelFormWidget({
    super.key,
    this.selectedValue,
    required this.listItems,
    this.onDropdownChanged,
    this.errorPlateNumber,
  });

  @override
  State<SelectCarModelFormWidget> createState() =>
      _SelectCarModelFormWidgetState();
}

class _SelectCarModelFormWidgetState extends State<SelectCarModelFormWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint(
      'onDropdownChanged is null: ${widget.onDropdownChanged == null}',
    );

    return Form(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderTFColor, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget.selectedValue,
                  isExpanded: true,
                  hint: const Text(
                    "Select a car model",
                    style: TextStyle(color: greyAppColor),
                  ),
                  icon: const Icon(Icons.unfold_more, color: Colors.grey),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 6,
                  items: widget.listItems.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: widget.onDropdownChanged,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              controller: TextEditingController(),
              label: 'Plate Number',
              hint: 'Start typing here...',
              error: widget.errorPlateNumber,
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}
