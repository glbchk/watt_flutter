import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/menu_pages/my_charging_stations_page/bloc/my_charging_stations_cubit.dart';
import 'package:watt/presentation/menu_pages/my_charging_stations_page/bloc/my_charging_stations_state.dart';
import 'package:watt/presentation/menu_pages/my_charging_stations_page/sub_pages/add_new_charger_station_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/empty_tall_card_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class MyChargingStationsPage extends StatefulWidget {
  const MyChargingStationsPage({super.key});

  @override
  State<MyChargingStationsPage> createState() => _MyChargingStationsPageState();
}

class _MyChargingStationsPageState extends State<MyChargingStationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyChargingStationsCubit>().fetchChargingStations();
    // context.read<MyChargingStationsCubit>().fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyChargingStationsCubit, MyChargingStationsState>(
      builder: (context, state) {
        final double marginSize = 10.0;

        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          appBarBackgroundColor: context.theme.appColors.transparent,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          leading: BackButton(
            onPressed: () {
              context.read<HomeCubit>().fetchUserData();
              Navigator.of(context).pop();
            },
          ),
          body: Stack(
            children: [
              CustomScrollView(
                physics: ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: wattGradient,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My charger stations',
                                style: TextStyle(
                                  color: context.theme.appColors.background,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                              Text(
                                'Here you can list your chargers and earn money',
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
                            minHeight:
                                MediaQuery.of(context).size.height / 1.27,
                          ),
                          child: Transform.translate(
                            offset: Offset(0, -40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.userChargingStations != null &&
                                    state.userChargingStations!.isNotEmpty) ...[
                                  Column(
                                    spacing: 10,
                                    children: [
                                      ...state.userChargingStations!.map((
                                        chargingStation,
                                      ) {
                                        return TallCardButton(
                                          isDismissible: true,
                                          dismissableKey: chargingStation.id,
                                          onDismissableDismissed: () {
                                            context
                                                .read<MyChargingStationsCubit>()
                                                .deleteChargingStation(
                                                  chargingStation.id,
                                                );
                                          },
                                          label:
                                              chargingStation
                                                  .chargingStationName ??
                                              '',
                                          pngImage: chargingStation.brandLogo,
                                          marginDistance: marginSize,
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (_) =>
                                            //         ChargingStationDetailsPage(),
                                            //   ),
                                            // );
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ] else ...[
                                  EmptyTallCardButton(
                                    label: 'No charger stations added',
                                    subLabel: 'Please add your charger below',
                                    marginDistance: marginSize,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 34,
                child: WattWhiteButton(
                  label: 'Add charger station',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddNewChargingStationPage(),
                      ),
                    ).then((_) async {
                      if (context.mounted) {
                        await context
                            .read<MyChargingStationsCubit>()
                            .fetchChargingStations();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
