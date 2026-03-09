import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_available_hours_property_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/extra_pages/choose_location_on_map_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/inline_button.dart';

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

  void _showOverlay() {
    _removeOverlay();

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: MediaQuery.of(context).size.width - 40,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: const Offset(0, 84),
            showWhenUnlinked: false,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: context.theme.appColors.onSecondary.withAlpha(38),
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: suggestions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == suggestions.length) {
                      return ListTile(
                        minTileHeight: 60,
                        leading: ClipOval(
                          child: Container(
                            color: context.theme.appColors.grey4,
                            width: 40,
                            height: 40,
                            child: Icon(
                              size: 24,
                              Icons.my_location,
                              color: context.theme.appColors.primary,
                            ),
                          ),
                        ),
                        title: const Text("Use my current location"),
                        onTap: () {
                          _removeOverlay();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailAvailableHoursPropertyPage(),
                            ),
                          );
                        },
                      );
                    }

                    final suggestion = suggestions[index];

                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: ListTile(
                        minTileHeight: 60,
                        leading: ClipOval(
                          child: Container(
                            color: context.theme.appColors.grey4,
                            width: 40,
                            height: 40,
                            child: Icon(
                              size: 24,
                              Icons.location_on_outlined,
                              color: context.theme.appColors.grey2,
                            ),
                          ),
                        ),
                        title: Text(suggestion),
                        onTap: () {
                          controllerAddress.text = suggestion;
                          _removeOverlay();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    controllerAddress.text = widget.address;
    super.initState();
  }

  @override
  void dispose() {
    controllerAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
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
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: context.theme.appColors.grey1,
                    label: 'Name',
                    hint: "e.g. John's Amp",
                    onChanged: (value) async {
                      if (value?.isEmpty ?? false) {
                        _removeOverlay();
                        return;
                      }

                      context.read<ChargingStationBloc>().add(
                        FetchLocationSuggestionsEvent(value ?? ''),
                      );
                      suggestions = state.locationSuggestions ?? [];
                      _showOverlay();
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
    );
  }
}
