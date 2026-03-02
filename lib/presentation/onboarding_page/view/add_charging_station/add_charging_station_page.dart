import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/add_charging_station_details_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';

List<String> chargingStationList = [
  KChargingStationsNames.abb,
  KChargingStationsNames.easee,
  KChargingStationsNames.garo,
  KChargingStationsNames.vattenfall,
  KChargingStationsNames.tesla,
  KChargingStationsNames.other,
];

List<String> chargingStationIconsList = [
  KChargingStationsLogos.abb,
  KChargingStationsLogos.easee,
  KChargingStationsLogos.garo,
  KChargingStationsLogos.vattenfall,
  KChargingStationsLogos.tesla,
  KChargingStationsLogos.other,
];

class AddChargingStationPage extends StatefulWidget {
  const AddChargingStationPage({super.key});

  @override
  State<AddChargingStationPage> createState() => _AddChargingStationPageState();
}

class _AddChargingStationPageState extends State<AddChargingStationPage> {
  final double marginSize = 10.0;

  String? createLabel(String? brandName, String? chargingEffect, String? plug) {
    if (brandName != null && chargingEffect != null && plug != null) {
      return '$brandName, $chargingEffect, $plug';
    }
    return null;
  }

  @override
  void initState() {
    context.read<OnboardingBloc>().add(
      FetchUserChargingStationsEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          appBarBackgroundColor: context.theme.appColors.transparent,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: wattGradient,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add your charger station',
                                style: TextStyle(
                                  color: context.theme.appColors.background,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                              Text(
                                'Add your charger station',
                                style: TextStyle(
                                  color: context.theme.appColors.background,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 60.0,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.appColors.background,
                          ),
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height / 1.3,
                          ),
                          child: Transform.translate(
                            offset: Offset(0, -40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.chargingStations != null &&
                                    state.chargingStations!.isNotEmpty) ...[
                                  ...state.chargingStations!.map((
                                    chargingStation,
                                  ) {
                                    return TallCardButton(
                                      label:
                                          chargingStation.chargingStationName ??
                                          '',
                                      subLabel: createLabel(
                                        chargingStation.brandName,
                                        chargingStation.chargingEffect,
                                        chargingStation.plug,
                                      ),
                                      subSubLabel:
                                          (chargingStation.pricePerKwh != null)
                                          ? "${chargingStation.pricePerKwh} SEK"
                                          : null,
                                      pngImage: chargingStation.brandLogo,
                                      marginDistance: marginSize,
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (_) =>
                                        //         ProfileCarDetailsPage(
                                        //           car: car,
                                        //         ),
                                        //   ),
                                        // );
                                      },
                                    );
                                  }),
                                  const SizedBox(height: 30.0),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Text(
                                      'Add Another Car'.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: context.theme.appColors.grey1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                ],
                                ...List.generate(
                                  chargingStationList.length,
                                  (index) {
                                    return TallCardButton(
                                      label: chargingStationList.elementAt(
                                        index,
                                      ),
                                      pngImage: chargingStationIconsList
                                          .elementAt(
                                            index,
                                          ),
                                      onPressed: () async {
                                        context.read<ChargingStationBloc>().add(
                                          SaveBrandNameChargingStationEvent(
                                            chargingStationList.elementAt(
                                              index,
                                            ),
                                            chargingStationIconsList.elementAt(
                                              index,
                                            ),
                                          ),
                                        );

                                        final result =
                                            await Navigator.push<
                                              ChargingStationModel
                                            >(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    AddChargingStationDetailsPage(),
                                              ),
                                            );

                                        if (!context.mounted) return;

                                        if (result != null) {
                                          context.read<OnboardingBloc>().add(
                                            FetchUserChargingStationsEvent(),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
