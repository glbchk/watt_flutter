import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_address_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_available_hours_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_bank_account_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_brand_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_charging_effect_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_name_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_plug_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_price_property_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

enum DetailPageProperties {
  chargingStationName,
  address,
  brandName,
  chargingEffect,
  plug,
  pricePerKwh,
  bankAccount,
  availableHours,
}

class DetailsPage extends StatefulWidget {
  final DetailPageProperties property;
  final String brandName;

  const DetailsPage({
    super.key,
    required this.property,
    required this.brandName,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();

  @override
  void dispose() {
    controllerName.dispose();
    controllerAddress.dispose();
    controllerPrice.dispose();
    super.dispose();
  }

  String titleSelector() {
    return switch (widget.property) {
      DetailPageProperties.chargingStationName => 'How to name your charger?',
      DetailPageProperties.address => 'Address',
      DetailPageProperties.brandName => 'Charging Station Brand',
      DetailPageProperties.chargingEffect => 'Charging effect',
      DetailPageProperties.plug => 'Plug',
      DetailPageProperties.pricePerKwh => 'Price per kWh',
      DetailPageProperties.bankAccount => 'Bank account',
      DetailPageProperties.availableHours => 'Available hours',
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(
              titleSelector(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            foregroundColor: Colors.black,
            backgroundColor: wattColorScheme.surface,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return switch (widget.property) {
                DetailPageProperties.chargingStationName =>
                  DetailNamePropertyWidget(
                    controllerName: controllerName,
                  ),
                DetailPageProperties.address => DetailAddressPropertyWidget(
                  controllerAddress: controllerAddress,
                ),
                DetailPageProperties.brandName => DetailBrandPropertyWidget(),
                DetailPageProperties.chargingEffect =>
                  DetailChargingEffectPropertyWidget(),
                DetailPageProperties.plug => DetailPlugPropertyWidget(),
                DetailPageProperties.pricePerKwh => DetailPricePropertyWidget(
                  controllerPrice: controllerPrice,
                ),
                DetailPageProperties.bankAccount =>
                  DetailBankAccountPropertyWidget(
                    onPress: () {},
                  ),
                DetailPageProperties.availableHours =>
                  DetailAvailableHoursPropertyWidget(
                    onPress: () {},
                  ),
              };
            },
          ),
          bottomNavigationBar: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(
              left: 20.0,
              top: 20.0,
              right: 20.0,
              bottom: 34.0,
            ),
            child:
                (state.isNameValid ?? false) ||
                    (state.isPhoneNumberValid ?? false)
                ? const SizedBox()
                : WattMainButton(
                    label: 'Save',
                    onPressed: () {},
                  ),
          ),
        );
      },
    );
  }
}
