import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/charger_station_details_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/details_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class AddChargingStationDetailsPage extends StatefulWidget {
  // final String brandName;

  const AddChargingStationDetailsPage({
    super.key,
    // required this.brandName,
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
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
        // final chargingStations = state.chargingStations;
        // final chargingStation =
        //     chargingStations!
        //         .where(
        //           (chargingStation) =>
        //               chargingStation.id == widget.chargingStationId,
        //         )
        //         .isNotEmpty
        //     ? chargingStations.firstWhere(
        //         (chargingStation) =>
        //             chargingStation.id == widget.chargingStationId,
        //       )
        //     : null;

        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          title: 'Charger station details',
          titleColor: context.theme.appColors.onPrimary,
          appBarBackgroundColor: context.theme.appColors.primary,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.theme.appColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: ChargerStationDetailsWidget(
                      chargingStationName: state.chargingStationName ?? '',
                      onNamePressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsPage(
                              property:
                                  DetailPageProperties.chargingStationName,
                            ),
                          ),
                        );
                      },
                      address: state.address ?? '',
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
                      brandName: state.brandName,
                      onBrandPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsPage(
                              property: DetailPageProperties.brandName,
                            ),
                          ),
                        );
                      },
                      chargingEffect: state.chargingEffect ?? '',
                      onChargingEffectPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsPage(
                              property: DetailPageProperties.chargingEffect,
                            ),
                          ),
                        );
                      },
                      plug: state.plug ?? '',
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
                      price: state.pricePerKwh ?? '',
                      onPricePressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsPage(
                              property: DetailPageProperties.pricePerKwh,
                            ),
                          ),
                        );
                      },
                      bankAccount: state.bankAccount ?? '',
                      onBankAccountPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsPage(
                              property: DetailPageProperties.bankAccount,
                            ),
                          ),
                        );
                      },
                      onOnlineChargerPressed: (bool value) {},
                      availableHours: 'Need to fix it',
                      onAvailableHoursPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsPage(
                              property: DetailPageProperties.availableHours,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(
              left: 20.0,
              top: 20.0,
              right: 20.0,
              bottom: 40.0,
            ),
            child: WattMainButton(
              label: 'Done',
              onPressed: () {
                final chargingStation = ChargingStationModel(
                  id: Uuid().v4(),
                  chargingStationName: state.chargingStationName,
                  address: state.address,
                  brandName: state.brandName,
                  brandLogo: state.brandLogo,
                  chargingEffect: state.chargingEffect,
                  plug: state.plug,
                  pricePerKwh: state.pricePerKwh,
                  bankAccount: state.bankAccount,
                  onlineCharger: state.onlineCharger,
                  availableHours: state.availableHours,
                  everyoneCanAccess: state.everyoneCanAccess,
                );

                context.read<ChargingStationBloc>().add(
                  AddChargingStationEvent(chargingStation),
                );

                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}
