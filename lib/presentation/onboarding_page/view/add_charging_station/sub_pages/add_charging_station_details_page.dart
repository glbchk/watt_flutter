import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/charger_station_details_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/details_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_bloc.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
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

  String days = '';

  @override
  void initState() {
    final state = context.read<PaymentMethodBloc>().state;
    final paymentMethods = state.paymentMethods;
    if (paymentMethods != null) {
      for (final method in paymentMethods) {
        if (method is IbanModel) {
          paymentMethod = method;
        }
      }
    }

    final stateSlots = context.read<ChargingStationBloc>().state;
    final String daysString =
        (stateSlots.availableHours?.first.availableDays ?? [])
            .map((e) => e.name.substring(0, 3))
            .join(', ');
    days = daysString;

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
                      bankAccount:
                          state.bankAccount?.ibanNumber?.substring(0, 18) ?? '',
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
                      availableHours:
                          '${state.availableHours?.first.startTime ?? ''} - ${state.availableHours?.first.endTime ?? ''}',
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

                  context.read<ChargingStationBloc>().add(
                    ResetChargingStationFormEvent(),
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
