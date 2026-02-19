import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/watt_dropdown_menu.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class SelectCarModelWidget extends StatefulWidget {
  final TextEditingController controllerPlateNumber;
  final String? selectedValue;
  final List<String> listItems;
  final ValueChanged<String?>? onDropdownChanged;
  final String? errorPlateNumber;
  final String? saveLabel;
  final VoidCallback? onSavePressed;

  const SelectCarModelWidget({
    super.key,
    required this.controllerPlateNumber,
    this.selectedValue,
    required this.listItems,
    this.onDropdownChanged,
    this.errorPlateNumber,
    this.saveLabel,
    this.onSavePressed,
  });

  @override
  State<SelectCarModelWidget> createState() => _SelectCarModelWidgetState();
}

class _SelectCarModelWidgetState extends State<SelectCarModelWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint(
      'onDropdownChanged is null: ${widget.onDropdownChanged == null}',
    );

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.appColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                top: 20.0,
                right: 20.0,
                bottom: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WattDropdownMenu(
                    label: 'Model',
                    hintText: "Select a car model",
                    dropdownValue: widget.selectedValue,
                    listItems: widget.listItems,
                    onChanged: widget.onDropdownChanged,
                  ),

                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: widget.controllerPlateNumber,
                    label: 'Plate Number',
                    hint: 'Start typing here...',
                    error: widget.errorPlateNumber,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 35.0),
                  WattMainButton(
                    label: 'Save',
                    onPressed: widget.onSavePressed,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
