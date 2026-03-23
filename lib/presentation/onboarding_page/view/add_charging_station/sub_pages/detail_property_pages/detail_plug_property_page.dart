import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/utils/global_components/tile_selector_widget.dart';
import 'package:watt/utils/global_methods/ui_helper_methods.dart';

class DetailPlugPropertyPage extends StatefulWidget {
  final String selectedValue;

  const DetailPlugPropertyPage({
    super.key,
    required this.selectedValue,
  });

  @override
  State<DetailPlugPropertyPage> createState() => _DetailPlugPropertyPageState();
}

class _DetailPlugPropertyPageState extends State<DetailPlugPropertyPage> {
  String? selectedPlug;

  @override
  void initState() {
    context.read<ChargingStationBloc>().add(
      FetchMockedPlugOptionsEvent(),
    );
    selectedPlug = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
        return DetailsWidget(
          title: 'Plug',
          content: state.isLoading
              ? UiHelperMethods.buildListOptionsShimmer(context)
              : TileSelectorWidget(
                  prefixIcon: Icons.settings_input_hdmi_outlined,
                  list: state.plugOptions ?? [],
                  selectedValue: selectedPlug,
                  onSelected: (String value) {
                    setState(() {
                      selectedPlug = value;
                    });
                  },
                ),
          onPressed: () {
            context.read<ChargingStationBloc>().add(
              SavePlugPropertyEvent(
                selectedPlug ?? '',
              ),
            );

            Navigator.pop(context);
          },
        );
      },
    );
  }
}
