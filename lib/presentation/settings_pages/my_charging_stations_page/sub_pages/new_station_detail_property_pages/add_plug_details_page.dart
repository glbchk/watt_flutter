import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/bloc/my_charging_stations_cubit.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/bloc/my_charging_stations_state.dart';
import 'package:watt/utils/global_components/tile_selector_widget.dart';
import 'package:watt/utils/global_methods/ui_helper_methods.dart';

class AddStationPlugDetailsPage extends StatefulWidget {
  final String selectedValue;

  const AddStationPlugDetailsPage({
    super.key,
    required this.selectedValue,
  });

  @override
  State<AddStationPlugDetailsPage> createState() =>
      _AddStationPlugDetailsPageState();
}

class _AddStationPlugDetailsPageState extends State<AddStationPlugDetailsPage> {
  String? selectedPlug;

  @override
  void initState() {
    context.read<MyChargingStationsCubit>().fetchMockedPlugOptionsData();
    selectedPlug = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyChargingStationsCubit, MyChargingStationsState>(
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
            // context.read<ChargingStationBloc>().add(
            //   SavePlugPropertyEvent(
            //     selectedPlug ?? '',
            //   ),
            // );

            Navigator.pop(context);
          },
        );
      },
    );
  }
}
