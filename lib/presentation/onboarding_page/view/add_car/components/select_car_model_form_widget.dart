import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class SelectCarModelFormWidget extends StatefulWidget {
  final TextEditingController controllerPlateNumber;
  final String label;
  final String? selectedValue;
  final List<String> listItems;
  final ValueChanged<String?>? onDropdownChanged;
  final String? errorPlateNumber;
  final String? saveLabel;
  final VoidCallback? onSavePressed;

  const SelectCarModelFormWidget({
    super.key,
    required this.controllerPlateNumber,
    required this.label,
    this.selectedValue,
    required this.listItems,
    this.onDropdownChanged,
    this.errorPlateNumber,
    this.saveLabel,
    this.onSavePressed,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: greyAppColor,
              ),
            ),
            SizedBox(height: 8.0),
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
              controller: widget.controllerPlateNumber,
              label: 'Plate Number',
              hint: 'Start typing here...',
              error: widget.errorPlateNumber,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 35.0),
            WattMainButton(
              label: widget.saveLabel ?? '',
              onPressed: widget.onSavePressed,
            ),
          ],
        ),
      ),
    );
  }
}
