import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/bloc/my_charging_stations_cubit.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';

class AddStationNameDetailsPage extends StatefulWidget {
  final String name;

  const AddStationNameDetailsPage({
    super.key,
    required this.name,
  });

  @override
  State<AddStationNameDetailsPage> createState() =>
      _AddStationNameDetailsPageState();
}

class _AddStationNameDetailsPageState extends State<AddStationNameDetailsPage> {
  TextEditingController controllerName = TextEditingController();

  @override
  void initState() {
    controllerName.text = widget.name;
    super.initState();
  }

  @override
  void dispose() {
    controllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsWidget(
      title: 'How to name your charger?',
      content: Container(
        color: context.theme.appColors.background,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'This name will be visible for other users on the\n map in the Watt app',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            CustomTextField(
              controller: controllerName,
              label: 'Name',
              hint: "e.g. John's Amp",
            ),
          ],
        ),
      ),
      onPressed: () {
        context.read<MyChargingStationsCubit>().saveChargingStationName(
          controllerName.text,
        );

        Navigator.pop(context);
      },
    );
  }
}
