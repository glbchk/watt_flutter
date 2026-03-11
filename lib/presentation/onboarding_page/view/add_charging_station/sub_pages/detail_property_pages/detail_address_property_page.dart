import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/extra_pages/choose_location_on_map_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/inline_button.dart';
import 'package:watt/utils/global_methods/ui_helper_methods.dart';

class DetailAddressPropertyPage extends StatefulWidget {
  final String address;
  final VoidCallback? onPressedCurrentLocation;
  final VoidCallback? onPressedChooseOnMap;

  const DetailAddressPropertyPage({
    super.key,
    required this.address,
    this.onPressedCurrentLocation,
    this.onPressedChooseOnMap,
  });

  @override
  State<DetailAddressPropertyPage> createState() =>
      _DetailAddressPropertyPageState();
}

class _DetailAddressPropertyPageState extends State<DetailAddressPropertyPage> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  TextEditingController controllerAddress = TextEditingController();
  List<String> suggestions = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    controllerAddress.text = widget.address;

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _overlayEntry = UiHelperMethods.removeOverlay(_overlayEntry);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controllerAddress.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChargingStationBloc, ChargingStationState>(
      listener: (context, state) {
        suggestions = state.locationSuggestions ?? [];

        _overlayEntry = UiHelperMethods.removeOverlay(_overlayEntry);

        if (suggestions.isEmpty) return;

        _overlayEntry = UiHelperMethods.showOverlay(
          context: context,
          layerLink: _layerLink,
          suggestions: suggestions,
          controller: controllerAddress,
          focusNode: _focusNode,
          onDismiss: () {
            _overlayEntry = UiHelperMethods.removeOverlay(_overlayEntry);
          },
        );
      },
      child: BlocBuilder<ChargingStationBloc, ChargingStationState>(
        builder: (context, state) {
          return DetailsWidget(
            title: 'Address',
            content: Container(
              color: context.theme.appColors.background,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: CustomTextField(
                      controller: controllerAddress,
                      focusNode: _focusNode,
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: context.theme.appColors.grey1,
                      label: 'Name',
                      hint: "e.g. John's Amp",
                      suffixIcon: Icon(Icons.close),
                      suffixIconColor: context.theme.appColors.grey1,
                      onSuffixIconTap: () {
                        _overlayEntry = UiHelperMethods.removeOverlay(
                          _overlayEntry,
                        );
                      },
                      onChanged: (value) async {
                        context.read<ChargingStationBloc>().add(
                          FetchLocationSuggestionsEvent(value ?? ''),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  InlineButton(
                    label: 'Use my current location',
                    icon: Icons.my_location,
                    onPressed: widget.onPressedCurrentLocation,
                  ),
                  InlineButton(
                    label: 'Choose location on map',
                    icon: Icons.location_on_outlined,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChooseLocationOnMapPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            onPressed: () {
              context.read<ChargingStationBloc>().add(
                SaveAddressPropertyEvent(
                  controllerAddress.text,
                ),
              );

              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
