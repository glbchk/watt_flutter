import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/bloc/my_charging_stations_cubit.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/bloc/my_charging_stations_state.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/sub_pages/charging_station_details_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_methods/ui_helper_methods.dart';

class AddNewChargingStationPage extends StatefulWidget {
  const AddNewChargingStationPage({super.key});

  @override
  State<AddNewChargingStationPage> createState() =>
      _AddNewChargingStationPageState();
}

class _AddNewChargingStationPageState extends State<AddNewChargingStationPage> {
  final double marginSize = 10.0;

  @override
  void initState() {
    // context.read<MyChargingStationsCubit>().add(
    //   FetchUserChargingStationsEvent(),
    // );
    context
        .read<MyChargingStationsCubit>()
        .fetchMockedChargingStationOptionsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyChargingStationsCubit, MyChargingStationsState>(
      builder: (context, state) {
        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          appBarBackgroundColor: context.theme.appColors.transparent,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          leading: BackButton(
            onPressed: () async {
              if (!(state.userChargingStations?.isEmpty ?? true)) {
                context.read<OnboardingBloc>().add(
                  AddedChargingStationsEvent(
                    chargingStations: state.userChargingStations ?? [],
                  ),
                );
              }
              Navigator.pop(context);
            },
          ),
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
                                'Select your charger',
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
                                Column(
                                  spacing: 10,
                                  children: [
                                    state.isLoading
                                        ? UiHelperMethods.buildCarOptionsShimmer(
                                            context,
                                          )
                                        : Column(
                                            spacing: 10,
                                            children: [
                                              ...(state.chargingStationOptions ?? []).map((
                                                option,
                                              ) {
                                                return TallCardButton(
                                                  isDismissible: false,
                                                  label: option.name,
                                                  pngImage: option.logo,
                                                  marginDistance: marginSize,
                                                  onPressed: () async {
                                                    context
                                                        .read<
                                                          MyChargingStationsCubit
                                                        >()
                                                        .saveBrandAndLogoChargingStation(
                                                          option.name,
                                                          option.logo,
                                                        );

                                                    final result =
                                                        await Navigator.push<
                                                          ChargingStationModel?
                                                        >(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                ChargingStationDetailsPage(),
                                                          ),
                                                        );

                                                    if (!context.mounted)
                                                      return;

                                                    if (result != null) {
                                                      final updatedState = context
                                                          .read<
                                                            ChargingStationBloc
                                                          >()
                                                          .state;
                                                      context
                                                          .read<
                                                            OnboardingBloc
                                                          >()
                                                          .add(
                                                            AddedChargingStationsEvent(
                                                              chargingStations:
                                                                  updatedState
                                                                      .chargingStations ??
                                                                  [],
                                                            ),
                                                          );
                                                    }
                                                  },
                                                );
                                              }),
                                            ],
                                          ),
                                  ],
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
              if (!(state.userChargingStations?.isEmpty ?? true))
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.appColors.background,
                      boxShadow: [
                        BoxShadow(
                          color: context.theme.appColors.onSecondary.withAlpha(
                            26,
                          ),
                          spreadRadius: 0,
                          blurRadius: 30,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      top: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                    child: SafeArea(
                      child: WattMainButton(
                        label: 'Save',
                        onPressed: () {
                          final stations = state.userChargingStations ?? [];
                          context.read<OnboardingBloc>().add(
                            AddedChargingStationsEvent(
                              chargingStations: stations,
                            ),
                          );
                          Navigator.pop(
                            context,
                            stations.isNotEmpty ? stations.first : null,
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
