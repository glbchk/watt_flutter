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
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/row_button.dart';
import 'package:watt/utils/global_components/row_toggle.dart';
import 'package:watt/utils/global_components/watt_alert.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

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
                                  builder: (_) => DetailNamePropertyPage(
                                    name: state.chargingStationName ?? '',
                                  ),
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
                                  builder: (_) => DetailAddressPropertyPage(
                                    address: state.address ?? '',
                                  ),
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
                            secondLabel: state.pricePerKwh != ""
                                ? '${state.pricePerKwh ?? ''} SEK'
                                : null,
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
                            secondLabel: state.bankAccounts?.isNotEmpty ?? false
                                ? state.bankAccounts?.first.ibanNumber
                                          ?.substring(
                                            0,
                                            18,
                                          ) ??
                                      ''
                                : null,
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
                                (state.availableHours?.isNotEmpty ?? false)
                                ? '${StringHelperMethods.formatDayRanges(state.availableHours?.first.availableDays)}, ${state.availableHours?.first.startTime ?? ''} - ${state.availableHours?.first.endTime ?? ''}'
                                : null,
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
                  id: Uuid().v4(),
                  chargingStationName: state.chargingStationName,
                  address: state.address,
                  brandName: state.brandName,
                  brandLogo: state.brandLogo,
                  chargingEffect: state.chargingEffect,
                  plug: state.plug,
                  pricePerKwh: state.pricePerKwh,
                  bankAccount: paymentMethod,
                  onlineCharger: isOnlineChargerOn,
                  availableHours: state.availableHours,
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
