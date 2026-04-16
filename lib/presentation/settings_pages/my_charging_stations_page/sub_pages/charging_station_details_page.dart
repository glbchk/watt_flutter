import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/bloc/my_charging_stations_cubit.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/bloc/my_charging_stations_state.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/sub_pages/new_station_detail_property_pages/add_address_details_page.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/sub_pages/new_station_detail_property_pages/add_available_hours_details_page.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/sub_pages/new_station_detail_property_pages/add_brand_details_page.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/sub_pages/new_station_detail_property_pages/add_charging_effect_details_page.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/sub_pages/new_station_detail_property_pages/add_plug_details_page.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/sub_pages/new_station_detail_property_pages/add_price_details_page.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/sub_pages/new_station_detail_property_pages/add_station_name_details_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/row_button.dart';
import 'package:watt/utils/global_components/row_toggle.dart';
import 'package:watt/utils/global_components/watt_alert.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class ChargingStationDetailsPage extends StatefulWidget {
  const ChargingStationDetailsPage({super.key});

  @override
  State<ChargingStationDetailsPage> createState() =>
      _ChargingStationDetailsPageState();
}

class _ChargingStationDetailsPageState
    extends State<ChargingStationDetailsPage> {
  IbanModel paymentMethod = IbanModel(
    id: '',
    isUsedForReceivingEarnings: false,
  );

  bool isOnlineChargerOn = false;
  bool isEveryoneCanAccess = false;

  @override
  void initState() {
    final state = context.read<ChargingStationBloc>().state;
    final paymentMethods = state.bankAccounts;
    if (paymentMethods != null) {
      for (final method in paymentMethods) {
        paymentMethod = method;
      }
    }

    isOnlineChargerOn = state.onlineCharger ?? false;
    isEveryoneCanAccess = state.everyoneCanAccess ?? false;

    // context.read<ChargingStationBloc>().add(
    //   ResetChargingStationFormEvent(),
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyChargingStationsCubit, MyChargingStationsState>(
      builder: (context, state) {
        final station = state.chargingStation;

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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RowButton(
                            label: 'Name',
                            secondLabel: station?.chargingStationName ?? '',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddStationNameDetailsPage(
                                    name: station?.chargingStationName ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Address',
                            secondLabel: station?.address ?? '',
                            onPressed: () {
                              //TODO: NEED TO BE FIXED
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddStationAddressDetailsPage(
                                    address: station?.address ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Brand',
                            secondLabel: station?.brandName,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddStationBrandDetailsPage(
                                    selectedBrand: station?.brandName ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Charging effect',
                            secondLabel: station?.chargingEffect ?? '',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddStationChargingEffectDetailsPage(
                                        selectedValue:
                                            station?.chargingEffect ?? '',
                                      ),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Plug',
                            secondLabel: station?.plug ?? '',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddStationPlugDetailsPage(
                                    selectedValue: station?.plug ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Price per kWh',
                            secondLabel: station?.pricePerKwh != ""
                                ? '${station?.pricePerKwh ?? ''} SEK'
                                : null,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddStationPriceDetailsPage(
                                    savedPrice: station?.pricePerKwh ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                          RowToggle(
                            label: 'Online charger',
                            isSwitched: isOnlineChargerOn,
                            onChanged: (bool value) {
                              setState(() {
                                isOnlineChargerOn = value;
                              });
                              print(isOnlineChargerOn);
                            },
                          ),
                          RowButton(
                            label: 'Available hours',
                            secondLabel:
                                (station?.availableHours?.isNotEmpty ?? false)
                                ? '${StringHelperMethods.formatDayRanges(station?.availableHours?.first.availableDays)}, ${station?.availableHours?.first.startTime ?? ''} - ${station?.availableHours?.first.endTime ?? ''}'
                                : null,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddStationAvailableHoursDetailsPage(),
                                ),
                              );
                            },
                          ),
                          RowToggle(
                            label: 'Everyone can access',
                            isSwitched: isEveryoneCanAccess,
                            onChanged: (bool value) {
                              setState(() {
                                isEveryoneCanAccess = value;
                              });
                              print(isEveryoneCanAccess);
                            },
                          ),
                        ],
                      ),
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
                  type: ChargingStationType.private,
                  id: Uuid().v4(),
                  chargingStationName: station?.chargingStationName,
                  address: station?.address,
                  addressLatitude: station?.addressLatitude,
                  addressLongitude: station?.addressLongitude,
                  brandName: station?.brandName,
                  brandLogo: station?.brandLogo,
                  chargingEffect: station?.chargingEffect,
                  plug: station?.plug,
                  pricePerKwh: station?.pricePerKwh,
                  bankAccount: paymentMethod,
                  onlineCharger: isOnlineChargerOn,
                  availableHours: station?.availableHours,
                  everyoneCanAccess: isEveryoneCanAccess,
                );

                final Map<String, dynamic> stationMap = chargingStation
                    .toJson();

                final entries = stationMap.entries.toList();
                final iterator = entries.iterator;

                List<String> missingProperties = [];

                while (iterator.moveNext()) {
                  final key = iterator.current.key;
                  final value = iterator.current.value;

                  if (value == null || value.toString().isEmpty) {
                    missingProperties.add(key);
                  }
                }

                if (missingProperties.isNotEmpty) {
                  final missingText = missingProperties.join("\n");

                  WattAlertWidget.show(
                    context: context,
                    title: 'Missing Information',
                    message:
                        'The following fields are required:\n\n$missingText',
                    buttonLabel: 'Understood',
                    onConfirm: () {
                      Navigator.pop(context);
                    },
                  );
                } else {
                  context.read<ChargingStationBloc>().add(
                    AddOneChargingStationEvent(chargingStation),
                  );
                  // context.read<ChargingStationBloc>().add(
                  //   ResetChargingStationFormEvent(),
                  // );
                  Navigator.pop(context);
                }
                ;
              },
            ),
          ),
        );
      },
    );
  }
}
