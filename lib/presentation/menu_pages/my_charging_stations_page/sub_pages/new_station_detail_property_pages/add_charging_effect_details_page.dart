import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/menu_pages/my_charging_stations_page/bloc/my_charging_stations_cubit.dart';
import 'package:watt/presentation/menu_pages/my_charging_stations_page/bloc/my_charging_stations_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/utils/global_components/tile_selector_widget.dart';
import 'package:watt/utils/global_methods/ui_helper_methods.dart';

class AddStationChargingEffectDetailsPage extends StatefulWidget {
  final String selectedValue;

  const AddStationChargingEffectDetailsPage({
    super.key,
    required this.selectedValue,
  });

  @override
  State<AddStationChargingEffectDetailsPage> createState() =>
      _AddStationChargingEffectDetailsPageState();
}

class _AddStationChargingEffectDetailsPageState
    extends State<AddStationChargingEffectDetailsPage> {
  String? selectedChargingEffect;

  @override
  void initState() {
    context
        .read<MyChargingStationsCubit>()
        .fetchMockedChargingEffectOptionsData();
    selectedChargingEffect = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyChargingStationsCubit, MyChargingStationsState>(
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
            context.read<MyChargingStationsCubit>().saveChargingEffect(
              selectedChargingEffect ?? '',
            );

            Navigator.pop(context);
          },
        );
      },
    );
  }
}
