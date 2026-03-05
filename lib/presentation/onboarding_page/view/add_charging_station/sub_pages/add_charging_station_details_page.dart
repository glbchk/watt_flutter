import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_address_property_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_available_hours_property_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_bank_account_property_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_brand_property_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_charging_effect_property_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_name_property_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_plug_property_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_price_property_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/row_button.dart';
import 'package:watt/utils/global_components/row_toggle.dart';
import 'package:watt/utils/global_components/watt_alert.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class AddChargingStationDetailsPage extends StatefulWidget {
  const AddChargingStationDetailsPage({super.key});

  @override
  State<AddChargingStationDetailsPage> createState() =>
      _AddChargingStationDetailsPageState();
}

class _AddChargingStationDetailsPageState
    extends State<AddChargingStationDetailsPage> {
  IbanModel paymentMethod = IbanModel(
    id: '',
    isUsedForReceivingEarnings: false,
  );

  // String days = '';
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

    // final stateSlots = context.read<ChargingStationBloc>().state;
    // final String daysString =
    //     (stateSlots.availableHours?.first.availableDays ?? [])
    //         .map((e) => e.name.substring(0, 3))
    //         .join(', ');
    // days = daysString;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
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
                            secondLabel: state.chargingStationName ?? '',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailNamePropertyPage(),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Address',
                            secondLabel: state.address ?? '',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailAddressPropertyPage(),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Brand',
                            secondLabel: state.brandName,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailBrandPropertyPage(
                                    selectedBrand: state.brandName ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Charging effect',
                            secondLabel: state.chargingEffect ?? '',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailChargingEffectPropertyPage(
                                        selectedValue:
                                            state.chargingEffect ?? '',
                                      ),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Plug',
                            secondLabel: state.plug ?? '',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPlugPropertyPage(
                                    selectedValue: state.plug ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Price per kWh',
                            secondLabel: state.pricePerKwh != ''
                                ? '${state.pricePerKwh ?? ''} SEK'
                                : '',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPricePropertyPage(
                                    savedPrice: state.pricePerKwh ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                          RowButton(
                            label: 'Bank account',
                            secondLabel:
                                state.bankAccounts?.first.ibanNumber?.substring(
                                  0,
                                  18,
                                ) ??
                                '',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailBankAccountPropertyPage(),
                                ),
                              );
                            },
                          ),
                          RowToggle(
                            label: 'Online charger',
                            isSwitched: isOnlineChargerOn,
                            onChanged: (bool value) {},
                          ),
                          RowButton(
                            label: 'Available hours',
                            secondLabel:
                                '${formatDayRanges(state.availableHours?.first.availableDays)}, ${state.availableHours?.first.startTime ?? ''} - ${state.availableHours?.first.endTime ?? ''}',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailAvailableHoursPropertyPage(),
                                ),
                              );
                            },
                          ),
                          RowToggle(
                            label: 'Everyone can access',
                            isSwitched: isEveryoneCanAccess,
                            onChanged: (bool value) {},
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
                  id: Uuid().v4(),
                  chargingStationName: state.chargingStationName,
                  address: state.address,
                  brandName: state.brandName,
                  brandLogo: state.brandLogo,
                  chargingEffect: state.chargingEffect,
                  plug: state.plug,
                  pricePerKwh: state.pricePerKwh,
                  bankAccount: paymentMethod,
                  onlineCharger: state.onlineCharger,
                  availableHours: state.availableHours,
                  everyoneCanAccess: state.everyoneCanAccess,
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

                  WattAlert.show(
                    context: context,
                    title: 'Missing Information',
                    message:
                        'The following fields are required:\n\n$missingText',
                    buttonLabel: 'Understood',
                  );
                } else {
                  context.read<ChargingStationBloc>().add(
                    AddChargingStationEvent(chargingStation),
                  );

                  Navigator.pop(context, chargingStation);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

String _formatRange(int start, int end) {
  if (start == end) {
    return KChargingStation.daysList[start] ?? '';
  }

  return '${KChargingStation.daysList[start]}-${KChargingStation.daysList[end]}';
}

String formatDayRanges(List<int>? chosenDays) {
  if (chosenDays == null || chosenDays.isEmpty) return '';

  final sortedDays = List<int>.from(chosenDays)..sort();

  List<String> groups = [];
  int start = sortedDays.first;
  int prev = sortedDays.first;

  for (int i = 1; i < sortedDays.length; i++) {
    int current = sortedDays[i];

    if (current != prev + 1) {
      groups.add(_formatRange(start, prev));
      start = current;
    }

    prev = current;
  }

  groups.add(_formatRange(start, prev));

  return groups.join(', ');
}
