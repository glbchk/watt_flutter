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
  TextEditingController controllerAddress = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool showSuggestions = false;

  @override
  void initState() {
    controllerAddress.text = widget.address;

    _focusNode.addListener(() {
      if (!mounted) return;

      setState(() {
        showSuggestions = _focusNode.hasFocus;
      });
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
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
        final suggestions = state.locationSuggestions ?? [];

        return Stack(
          children: [
            DetailsWidget(
              title: 'Address',
              content: Container(
                color: context.theme.appColors.background,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: controllerAddress,
                      label: 'Address',
                      focusNode: _focusNode,
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: context.theme.appColors.grey1,
                      hint: "e.g. John's Amp",
                      suffixIcon: Icon(Icons.close),
                      suffixIconColor: context.theme.appColors.grey1,
                      onSuffixIconTap: () {
                        _focusNode.unfocus();

                        setState(() {
                          showSuggestions = false;
                        });
                      },
                      onChanged: (value) {
                        context.read<ChargingStationBloc>().add(
                          FetchLocationSuggestionsEvent(value ?? ''),
                        );
                      },
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    InlineButton(
                      label: 'Use my current location',
                      icon: Icons.my_location,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChooseLocationOnMapPage(
                              autoDetectMyLocation: true,
                            ),
                          ),
                        );
                      },
                    ),
                    InlineButton(
                      label: 'Choose location on map',
                      icon: Icons.location_on_outlined,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChooseLocationOnMapPage(
                              autoDetectMyLocation: false,
                              findOnMapLocation: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              onPressed: () {
                // context.read<ChargingStationBloc>().add(
                //   SaveAddressPropertyEvent(
                //     state.address ?? "",
                //     state.addressLatLng,
                //   ),
                // );

                Navigator.pop(context);
              },
            ),
            if (showSuggestions && suggestions.isNotEmpty)
              Positioned(
                top: 222,
                left: 20,
                right: 20,
                child: Material(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(10),
                  color: context.theme.appColors.surface,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 400,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.appColors.background,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
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
                            title: const Text(
                              "Use my current location",
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ChooseLocationOnMapPage(
                                    autoDetectMyLocation: true,
                                  ),
                                ),
                              );

                              _focusNode.unfocus();

                              setState(() {
                                showSuggestions = false;
                              });
                            },
                          );
                        }
                        final suggestion = suggestions[index];

                        return ListTile(
                          leading: const Icon(
                            Icons.location_on_outlined,
                          ),
                          title: Text(suggestion),
                          onTap: () {
                            controllerAddress.text = suggestion;
                            setState(() {
                              showSuggestions = false;
                            });
                            _focusNode.unfocus();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
