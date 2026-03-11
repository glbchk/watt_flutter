import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_methods/custom_input_formatters.dart';

class AddIbanInChargingStationPage extends StatefulWidget {
  const AddIbanInChargingStationPage({super.key});

  @override
  State<AddIbanInChargingStationPage> createState() =>
      _AddIbanDetailsPageState();
}

class _AddIbanDetailsPageState extends State<AddIbanInChargingStationPage> {
  TextEditingController ibanNumberController = TextEditingController();
  bool isUsedForReceivingEarnings = false;

  @override
  void dispose() {
    ibanNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChargingStationBloc, ChargingStationState>(
      listener: (context, state) {},

      builder: (context, state) {
        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          title: 'Credit card details',
          titleColor: context.theme.appColors.onPrimary,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          body: Container(
            decoration: BoxDecoration(
              color: context.theme.appColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Add IBAN to receive earnings for providing\n charging with your charging station',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: ibanNumberController,
                    label: 'Iban Number',
                    hint: '000000000000',
                    inputFormatters: [
                      IbanNumberFormatter(),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 12
                          : 34,
                    ),
                    child: WattMainButton(
                      label: 'Save',
                      onPressed: () {
                        final paymentMethod = IbanModel(
                          id: Uuid().v4(),
                          ibanNumber: ibanNumberController.text,
                          isUsedForReceivingEarnings: true,
                        );

                        context.read<ChargingStationBloc>().add(
                          AddIbanEvent(
                            iban: paymentMethod,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
