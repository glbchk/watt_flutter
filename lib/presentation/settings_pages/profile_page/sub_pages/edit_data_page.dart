import 'package:flutter/material.dart';
import 'package:watt/presentation/settings_pages/profile_page/components/edit_data_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';

enum EditDataType {
  editName,
  editEmail,
  editPhoneNumber,
}

class EditDataPage extends StatefulWidget {
  final EditDataType type;

  const EditDataPage({
    super.key,
    this.type = EditDataType.editName,
  });

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // controllerName.text = widget.name;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? title;
    String? label;
    String? value;

    switch (widget.type) {
      case EditDataType.editName:
        title = 'What is your name?';
        label = 'Name';
        value = 'Some name';
        break;
      case EditDataType.editEmail:
        title = 'What is your email?';
        label = 'Email';
        value = 'Some email';
        break;
      case EditDataType.editPhoneNumber:
        title = 'What is your phone number?';
        label = 'Phone Number';
        value = 'Some phone number';
        break;
    }

    controller.text = value;

    return EditDataWidget(
      title: title,
      content: Container(
        color: context.theme.appColors.background,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              controller: controller,
              autofocus: true,
              label: label,
              hint: "e.g. John's Amp",
            ),
          ],
        ),
      ),
      onPressed: () {
        // context.read<ChargingStationBloc>().add(
        //   SaveNamePropertyEvent(
        //     controllerName.text,
        //   ),
        // );

        Navigator.pop(context);
      },
    );
  }
}
