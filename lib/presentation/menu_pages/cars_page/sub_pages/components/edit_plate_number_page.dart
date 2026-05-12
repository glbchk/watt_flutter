import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class EditPlateNumberPage extends StatefulWidget {
  final String? initialPlateNumber;
  final void Function(String plateNumber)? onPressed;

  const EditPlateNumberPage({
    super.key,
    this.initialPlateNumber,
    this.onPressed,
  });

  @override
  State<EditPlateNumberPage> createState() => _EditPlateNumberPageState();
}

class _EditPlateNumberPageState extends State<EditPlateNumberPage> {
  final controllerPlateNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerPlateNumber.text = widget.initialPlateNumber ?? '';
  }

  @override
  void dispose() {
    controllerPlateNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultAppBar(
      resizeToAvoidBottomInset: true,
      title: 'Plate number changed?',
      foregroundColor: context.theme.appColors.onSurface,
      appBarBackgroundColor: context.theme.appColors.surface,
      scaffoldBackgroundColor: context.theme.appColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                controller: controllerPlateNumber,
                label: 'Plate number',
                hint: "XS2345",
                textCapitalization: TextCapitalization.characters,
              ),
              Spacer(),
              WattMainButton(
                label: 'Save',
                onPressed: () {
                  if (controllerPlateNumber.text.isNotEmpty) {
                    widget.onPressed?.call(controllerPlateNumber.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
