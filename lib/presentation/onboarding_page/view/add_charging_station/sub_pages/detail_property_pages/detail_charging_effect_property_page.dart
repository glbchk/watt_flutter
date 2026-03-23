import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/utils/global_components/tile_selector_widget.dart';
import 'package:watt/utils/global_methods/ui_helper_methods.dart';

class DetailChargingEffectPropertyPage extends StatefulWidget {
  final String selectedValue;

  const DetailChargingEffectPropertyPage({
    super.key,
    required this.selectedValue,
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
    context.read<ChargingStationBloc>().add(
      FetchMockedChargingEffectOptionsEvent(),
    );
    selectedChargingEffect = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
        return DetailsWidget(
          title: 'Charging effect',
          content: state.isLoading
              ? UiHelperMethods.buildListOptionsShimmer(context)
              : TileSelectorWidget(
                  list: state.chargingEffectOptions ?? [],
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
      },
    );
  }
}
