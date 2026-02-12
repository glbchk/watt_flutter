import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/charger_station_details_form_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/details_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';

class AddChargingStationDetailsPage extends StatefulWidget {
  final String chargingStationBrandName;

  const AddChargingStationDetailsPage({
    required this.chargingStationBrandName,
    super.key,
  });

  @override
  State<AddChargingStationDetailsPage> createState() =>
      _AddChargingStationDetailsPageState();
}

class _AddChargingStationDetailsPageState
    extends State<AddChargingStationDetailsPage> {
  @override
  void dispose() {
    // controllerName.dispose();
    // controllerPhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(
              'Charger station details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: wattColorScheme.primary,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: ChargerStationDetailsFormWidget(
                                onNamePressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property: DetailPageProperties
                                            .chargingStationName,
                                        brandName:
                                            widget.chargingStationBrandName,
                                      ),
                                    ),
                                  );
                                },
                                onAddressPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property: DetailPageProperties.address,
                                        brandName:
                                            widget.chargingStationBrandName,
                                      ),
                                    ),
                                  );
                                },
                                onBrandPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property:
                                            DetailPageProperties.brandName,
                                        brandName:
                                            widget.chargingStationBrandName,
                                      ),
                                    ),
                                  );
                                },
                                onChargingEffectPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property:
                                            DetailPageProperties.chargingEffect,
                                        brandName:
                                            widget.chargingStationBrandName,
                                      ),
                                    ),
                                  );
                                },
                                onPlugPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property: DetailPageProperties.plug,
                                        brandName:
                                            widget.chargingStationBrandName,
                                      ),
                                    ),
                                  );
                                },
                                onPricePressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property:
                                            DetailPageProperties.pricePerKwh,
                                        brandName:
                                            widget.chargingStationBrandName,
                                      ),
                                    ),
                                  );
                                },
                                onIbanPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property:
                                            DetailPageProperties.bankAccount,
                                        brandName:
                                            widget.chargingStationBrandName,
                                      ),
                                    ),
                                  );
                                },
                                onAvailableHoursPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property:
                                            DetailPageProperties.availableHours,
                                        brandName:
                                            widget.chargingStationBrandName,
                                      ),
                                    ),
                                  );
                                },
                                brandName: widget.chargingStationBrandName,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
