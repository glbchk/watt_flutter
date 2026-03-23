import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_methods/custom_input_formatters.dart';

class DetailPricePropertyPage extends StatefulWidget {
  // final TextEditingController controllerPrice;
  final String savedPrice;
  final String currency;

  const DetailPricePropertyPage({
    super.key,
    // required this.controllerPrice,
    required this.savedPrice,
    this.currency = 'SEK',
  });

  @override
  State<DetailPricePropertyPage> createState() =>
      _DetailPricePropertyPageState();
}

class _DetailPricePropertyPageState extends State<DetailPricePropertyPage> {
  TextEditingController controllerPrice = TextEditingController();

  @override
  void initState() {
    controllerPrice.text = widget.savedPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsWidget(
      title: 'Price per kWh',
      content: Container(
        color: context.theme.appColors.background,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'This price will be visible for other users, who\n wants to book your charger',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: context.theme.appColors.grey1,
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 58,
                ),
                Expanded(
                  child: TextFormField(
                    controller: controllerPrice,
                    autofocus: true,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                      final value = double.tryParse(
                        controllerPrice.text,
                      );
                      if (value != null) {
                        controllerPrice.text = value.toStringAsFixed(2);
                      }
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 28, color: Colors.black),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                      DoublePriceInputFormatter(),
                    ],
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(
                        color: context.theme.appColors.grey3,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.appColors.grey3,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.appColors.primary,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${widget.currency} / kWh',
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(
                  width: 58,
                ),
              ],
            ),
          ],
        ),
      ),
      onPressed: () {
        context.read<ChargingStationBloc>().add(
          SavePricePropertyEvent(
            controllerPrice.text,
          ),
        );

        Navigator.pop(context);
      },
    );
  }
}
