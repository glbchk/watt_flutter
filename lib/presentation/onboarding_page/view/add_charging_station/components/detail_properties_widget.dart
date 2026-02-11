import 'package:flutter/material.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/add_charging_station_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/details_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/inline_button.dart';
import 'package:watt/utils/global_components/tile_selector_widget.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

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
  final String currency;

  const DetailPropertiesWidget({
    super.key,
    required this.property,
    required this.brandName,
    this.currency = 'SEK',
  });

  @override
  State<DetailPropertiesWidget> createState() =>
      _DetailPropertiesFormWidgetState();
}

class _DetailPropertiesFormWidgetState extends State<DetailPropertiesWidget> {
  String? selectedChargingEffect;
  String? selectedPlug;
  TextEditingController controllerPriceKwh = TextEditingController();

  @override
  void dispose() {
    controllerPriceKwh.dispose();
    super.dispose();
  }

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
        prefixIcon: Icons.settings_input_hdmi_outlined,
        list: plugList,
        selectedValue: selectedPlug,
        onSelected: (value) {
          setState(() => selectedPlug = value);
        },
      ),
      DetailPageProperties.pricePerKwh => Form(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'This price will be visible for other users, who\n wants to book your charger',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: greyAppColor),
              ),
              SizedBox(
                height: 100.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 58,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controllerPriceKwh,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 28, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: TextStyle(color: borderTFColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${widget.currency} / kWh',
                    style: TextStyle(fontSize: 28),
                  ),
                  SizedBox(
                    width: 58,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      DetailPageProperties.iban => Form(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Choose IBAN or add new one to recieve earnings\n from your charging station',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              WattMainButton(
                label: 'Add IBAN',
                backgroundColor: Colors.white,
                textColor: wattBlackColor,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      DetailPageProperties.availableHours => Form(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Timeslot'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: greyAppColor,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: wattColorScheme.onSecondary.withAlpha(38),
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        ...List.generate(
                          daysList.length,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                              ),
                              child: ClipOval(
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  color: wattColorScheme.surface,
                                  child: Center(
                                    child: Text(
                                      daysList[index],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    Divider(
                      height: 1,
                      color: borderTFColor,
                    ),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Start',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            color: wattBlackColor,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: borderTFColor,
                    ),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'End',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            color: wattBlackColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              WattMainButton(
                label: 'Add timeslot',
                backgroundColor: Colors.white,
                textColor: wattBlackColor,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    };
  }
}
