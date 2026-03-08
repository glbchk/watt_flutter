import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/inline_button.dart';

import '../../../../../../utils/colors.dart';

class DetailAddressPropertyPage extends StatefulWidget {
  final String address;
  final VoidCallback? onPressedCurrentLocation;
  final VoidCallback? onPressedChooseOnMap;

  const DetailAddressPropertyPage({
    super.key,
    required this.address,
    this.onPressedCurrentLocation,
    this.onPressedChooseOnMap,
  });

  @override
  State<DetailAddressPropertyPage> createState() =>
      _DetailAddressPropertyPageState();
}

class _DetailAddressPropertyPageState extends State<DetailAddressPropertyPage> {
  TextEditingController controllerAddress = TextEditingController();

  @override
  void initState() {
    controllerAddress.text = widget.address;
    super.initState();
  }

  @override
  void dispose() {
    controllerAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsWidget(
      title: 'Address',
      content: Container(
        color: context.theme.appColors.background,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              controller: controllerAddress,
              prefixIcon: Icon(Icons.search),
              prefixIconColor: context.theme.appColors.grey1,
              label: 'Name',
              hint: "e.g. John's Amp",
            ),
            SizedBox(
              height: 20.0,
            ),
            InlineButton(
              label: 'Use my current location',
              icon: Icons.my_location,
              onPressed: widget.onPressedCurrentLocation,
            ),
            InlineButton(
              label: 'Choose location on map',
              icon: Icons.location_on_outlined,
              onPressed: widget.onPressedChooseOnMap,
            ),
          ],
        ),
      ),
      onPressed: () {
        context.read<ChargingStationBloc>().add(
          SaveAddressPropertyEvent(
            controllerAddress.text,
          ),
        );

        Navigator.pop(context);
      },
    );
  }
}
