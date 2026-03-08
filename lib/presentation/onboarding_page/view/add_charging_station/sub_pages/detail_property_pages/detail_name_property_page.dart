import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';

class DetailNamePropertyPage extends StatefulWidget {
  final String name;

  const DetailNamePropertyPage({
    super.key,
    required this.name,
  });

  @override
  State<DetailNamePropertyPage> createState() => _DetailNamePropertyPageState();
}

class _DetailNamePropertyPageState extends State<DetailNamePropertyPage> {
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
        context.read<ChargingStationBloc>().add(
          SaveNamePropertyEvent(
            controllerName.text,
          ),
        );

        Navigator.pop(context);
      },
    );
  }
}
