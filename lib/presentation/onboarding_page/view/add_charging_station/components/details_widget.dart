import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class DetailsWidget extends StatelessWidget {
  final String? chargingStationId;
  final String? brandName;
  final String title;
  final Widget content;
  final VoidCallback onPressed;

  const DetailsWidget({
    super.key,
    this.chargingStationId,
    this.brandName,
    required this.title,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
        return DefaultAppBar(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: false,
          title: title,
          foregroundColor: context.theme.appColors.onSurface,
          appBarBackgroundColor: context.theme.appColors.surface,

          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: content,
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
                      onPressed.call();
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
