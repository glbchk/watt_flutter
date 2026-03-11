import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

enum DetailPageProperties {
  chargingStationName,
  address,
  brandName,
  chargingEffect,
  plug,
  pricePerKwh,
  bankAccount,
  availableHours,
}

class DetailsWidget extends StatefulWidget {
  // final DetailPageProperties property;
  final String? chargingStationId;
  final String? brandName;
  final String title;
  final Widget content;
  final VoidCallback onPressed;

  const DetailsWidget({
    super.key,
    // required this.property,
    this.chargingStationId,
    this.brandName,
    required this.title,
    required this.content,
    required this.onPressed,
  });

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerStartTime = TextEditingController();
  TextEditingController controllerEndTime = TextEditingController();

  String? tempSelectedBrand;
  String? selectedChargingEffect;
  String? selectedPlugType;
  List<TimeSlotModel>? availableHours = [];

  @override
  void dispose() {
    controllerName.dispose();
    controllerAddress.dispose();
    controllerPrice.dispose();
    controllerStartTime.dispose();
    controllerEndTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
        return DefaultAppBar(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: false,
          title: widget.title,
          foregroundColor: context.theme.appColors.onSurface,
          appBarBackgroundColor: context.theme.appColors.surface,

          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: widget.content,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: 20.0,
                    right: 20.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0
                        ? 12
                        : 34,
                  ),
                  child: WattMainButton(
                    label: 'Save',
                    onPressed: () {
                      widget.onPressed();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
