import 'package:flutter/material.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/add_charging_station_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/details_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/inline_button.dart';
import 'package:watt/utils/global_components/tile_selector_widget.dart';

import '../../../../../utils/colors.dart';

List<String> chargingEffectList = [
  KChargingEffect.three,
  KChargingEffect.seven,
  KChargingEffect.eleven,
  KChargingEffect.twentyTwo,
];

List<String> plugList = [
  KPlugs.threePhase,
  KPlugs.typeOne,
  KPlugs.typeTwo,
  KPlugs.wall,
];

class DetailPropertiesWidget extends StatefulWidget {
  final DetailPageProperties property;
  final String brandName;

  const DetailPropertiesWidget({
    super.key,
    required this.property,
    required this.brandName,
  });

  @override
  State<DetailPropertiesWidget> createState() =>
      _DetailPropertiesFormWidgetState();
}

class _DetailPropertiesFormWidgetState extends State<DetailPropertiesWidget> {
  String? selectedChargingEffect;
  String? selectedPlug;

  @override
  Widget build(BuildContext context) {
    return switch (widget.property) {
      DetailPageProperties.chargingStationName => Form(
        child: Container(
          color: Colors.white,
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
                controller: TextEditingController(),
                label: 'Name',
                hint: "e.g. John's Amp",
              ),
            ],
          ),
        ),
      ),
      DetailPageProperties.address => Form(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                controller: TextEditingController(),
                prefixIcon: Icons.search,
                prefixIconColor: greyAppColor,
                label: 'Name',
                hint: "e.g. John's Amp",
              ),
              SizedBox(
                height: 20.0,
              ),
              InlineButton(
                label: 'Use my current location',
                icon: Icons.my_location,
              ),
              InlineButton(
                label: 'Choose location on map',
                icon: Icons.location_on_outlined,
              ),
            ],
          ),
        ),
      ),
      DetailPageProperties.brandName => Form(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              ...List.generate(
                chargingStationList.length,
                (index) {
                  return TallCardButton(
                    label: chargingStationList.elementAt(index),
                    pngImage: chargingStationIconsList.elementAt(index),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => AddChargingStationDetailsPage(
                      //       chargingStationBrandName: chargingStationList
                      //           .elementAt(
                      //             index,
                      //           ),
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      DetailPageProperties.chargingEffect => TileSelectorWidget(
        list: chargingEffectList,
        selectedValue: selectedChargingEffect,
        onSelected: (value) {
          setState(() => selectedChargingEffect = value);
        },
      ),
      DetailPageProperties.plug => TileSelectorWidget(
        list: plugList,
        selectedValue: selectedPlug,
        onSelected: (value) {
          setState(() => selectedPlug = value);
        },
      ),
      // TODO: Handle this case.
      DetailPageProperties.pricePerKwh => throw UnimplementedError(),
      // TODO: Handle this case.
      DetailPageProperties.iban => throw UnimplementedError(),
      // TODO: Handle this case.
      DetailPageProperties.availableHours => throw UnimplementedError(),
    };
  }
}
