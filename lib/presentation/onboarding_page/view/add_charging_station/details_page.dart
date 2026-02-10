import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/detail_properties_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';

enum DetailPageProperties {
  chargingStationName,
  address,
  brandName,
  chargingEffect,
  plug,
  pricePerKwh,
  iban,
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
  @override
  void dispose() {
    // controllerName.dispose();
    // controllerPhoneNumber.dispose();
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
      DetailPageProperties.iban => 'Bank account',
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
              return DetailPropertiesWidget(
                property: widget.property,
                brandName: widget.brandName,
              );
            },
          ),
          bottomNavigationBar: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(20.0),
            child:
                (state.isNameValid ?? false) ||
                    (state.isPhoneNumberValid ?? false)
                ? const SizedBox()
                : BottomFloatingButton(
                    label: 'Done',
                    callback: () {},
                  ),

            ///TODO: Need to fix color and update the BottomFloatingButton
            ///to have different styles through ENUM
          ),
        );
      },
    );
  }
}
