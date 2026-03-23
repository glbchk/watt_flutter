import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/extra_pages/add_iban_in_charging_station_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class DetailBankAccountPropertyPage extends StatefulWidget {
  // final VoidCallback onPress;

  const DetailBankAccountPropertyPage({
    super.key,
    // required this.onPress,
  });

  @override
  State<DetailBankAccountPropertyPage> createState() =>
      _DetailBankAccountPropertyPageState();
}

class _DetailBankAccountPropertyPageState
    extends State<DetailBankAccountPropertyPage> {
  final double marginSize = 15.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
        final bankAccounts = state.bankAccounts ?? [];

        return DetailsWidget(
          title: 'Bank account',
          content: Container(
            color: context.theme.appColors.background,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (bankAccounts.isNotEmpty)
                      Text(
                        'Added Timeslots'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.theme.appColors.grey1,
                        ),
                      ),
                    if (bankAccounts.isNotEmpty) ...[
                      Column(
                        spacing: 10,
                        children: [
                          ...bankAccounts.map((iban) {
                            return TallCardButton(
                              isDismissible: true,
                              dismissableKey: iban.id,
                              onDismissableDismissed: () {
                                context.read<ChargingStationBloc>().add(
                                  RemoveIbanEvent(iban.id),
                                );
                              },
                              padding: EdgeInsets.only(top: 2, bottom: 2),
                              label: 'ID: ${iban.id.substring(0, 8)}',
                              subLabel: iban.ibanNumber?.substring(0, 18) ?? '',
                              svgImage: KCardIcons.paymentMethod,
                              marginDistance: marginSize,
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) =>
                                //         AddCreditCardPage(),
                                //   ),
                                // );
                              },
                            );
                          }),
                        ],
                      ),
                    ],
                  ],
                ),
                if (bankAccounts.isEmpty)
                  Text(
                    'Choose IBAN or add new one to recieve earnings\n from your charging station',
                    textAlign: TextAlign.center,
                  ),
                SizedBox(
                  height: 20.0,
                ),
                WattWhiteButton(
                  label: 'Add IBAN',
                  textColor: context.theme.appColors.onSurface,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddIbanInChargingStationPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          onPressed: () {
            Navigator.pop(context, state.bankAccounts);
          },
        );
      },
    );
  }
}
