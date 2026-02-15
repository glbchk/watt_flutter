import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/charger_station_details_form_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/details_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';

class AddChargingStationDetailsPage extends StatefulWidget {
  final String chargingStationId;

  const AddChargingStationDetailsPage({
    super.key,
    required this.chargingStationId,
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
        final chargingStations = state.chargingStations;
        final chargingStation =
            chargingStations!
                .where(
                  (chargingStation) =>
                      chargingStation.id == widget.chargingStationId,
                )
                .isNotEmpty
            ? chargingStations.firstWhere(
                (chargingStation) =>
                    chargingStation.id == widget.chargingStationId,
              )
            : null;

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
                                chargingStationName:
                                    chargingStation?.chargingStationName ?? '',
                                onNamePressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property: DetailPageProperties
                                            .chargingStationName,
                                      ),
                                    ),
                                  );
                                },
                                address: chargingStation?.address ?? '',
                                onAddressPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property: DetailPageProperties.address,
                                      ),
                                    ),
                                  );
                                },
                                brandName: chargingStation?.brandName ?? '',
                                onBrandPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property:
                                            DetailPageProperties.brandName,
                                      ),
                                    ),
                                  );
                                },
                                chargingEffect:
                                    chargingStation?.chargingEffect ?? '',
                                onChargingEffectPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property:
                                            DetailPageProperties.chargingEffect,
                                      ),
                                    ),
                                  );
                                },
                                plug: chargingStation?.plug ?? '',
                                onPlugPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property: DetailPageProperties.plug,
                                      ),
                                    ),
                                  );
                                },
                                price: chargingStation?.pricePerKwh ?? '',
                                onPricePressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property:
                                            DetailPageProperties.pricePerKwh,
                                      ),
                                    ),
                                  );
                                },
                                bankAccount: chargingStation?.bankAccount ?? '',
                                onBankAccountPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property:
                                            DetailPageProperties.bankAccount,
                                      ),
                                    ),
                                  );
                                },
                                availableHours: 'Need to fix it',
                                onAvailableHoursPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                        property:
                                            DetailPageProperties.availableHours,
                                      ),
                                    ),
                                  );
                                },
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
            child: BottomFloatingButton(
              label: 'Done',
              callback: () {
                if (chargingStation != null) {
                  context.read<OnboardingBloc>().add(
                    OnboardingFilledChargingStationEvent(
                      chargingStation: chargingStation,
                    ),
                  );
                }
                Navigator.pop(context);
              },
            ),

            ///TODO: Need to fix color and update the BottomFloatingButton
            ///to have different styles through ENUM
          ),
        );
      },
    );
  }
}
