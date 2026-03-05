import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/tile_selector_widget.dart';

class DetailChargingEffectPropertyPage extends StatefulWidget {
  final String selectedValue;
  // final ValueChanged<String> onSelected;

  const DetailChargingEffectPropertyPage({
    super.key,
    required this.selectedValue,
    // required this.onSelected,
  });

  @override
  State<DetailChargingEffectPropertyPage> createState() =>
      _DetailChargingEffectPropertyPageState();
}

class _DetailChargingEffectPropertyPageState
    extends State<DetailChargingEffectPropertyPage> {
  String? selectedChargingEffect;

  @override
  void initState() {
    selectedChargingEffect = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsWidget(
      title: 'Charging effect',
      content: TileSelectorWidget(
        list: KChargingStation.chargingEffectList,
        selectedValue: selectedChargingEffect,
        onSelected: (String value) {
          setState(() {
            selectedChargingEffect = value;
          });
        },
      ),
      onPressed: () {
        context.read<ChargingStationBloc>().add(
          SaveChargingEffectPropertyEvent(
            selectedChargingEffect ?? '',
          ),
        );

        Navigator.pop(context);
      },
    );
  }
}
