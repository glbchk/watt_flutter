import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/search_bar_widget.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class ChooseLocationOnMapPage extends StatefulWidget {
  final bool autoDetectMyLocation;
  final bool findOnMapLocation;

  const ChooseLocationOnMapPage({
    super.key,
    this.autoDetectMyLocation = false,
    this.findOnMapLocation = false,
  });

  @override
  State<ChooseLocationOnMapPage> createState() =>
      _ChooseLocationOnMapPageState();
}

class _ChooseLocationOnMapPageState extends State<ChooseLocationOnMapPage> {
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool showSuggestions = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(51.5074, -0.1278), // Example: London
    zoom: 12,
  );

  GoogleMapController? _mapController;

  String address = '';

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChargingStationBloc, ChargingStationState>(
      listener: (context, state) {
        if (state.addressPosition != null && state.address != null) {
          final latLng = LatLng(
            state.addressPosition?.latitude ?? 0.0,
            state.addressPosition?.longitude ?? 0.0,
          );

          if (searchController.text != state.address) {
            searchController.text = state.address ?? "";
            searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: searchController.text.length),
            );
          }

          if (_mapController != null) {
            _mapController
                ?.animateCamera(
                  CameraUpdate.newLatLngZoom(latLng, 15),
                )
                .then((_) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _mapController?.showMarkerInfoWindow(
                      const MarkerId('selected_point'),
                    );
                  });
                });
          }
        }
      },
      builder: (context, state) {
        final suggestions = state.locationSuggestions ?? [];

        return DefaultAppBar(
          showAppBar: false,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          scaffoldBackgroundColor: context.theme.appColors.transparent,

          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: state.addressPosition != null
                    ? CameraPosition(
                        target: LatLng(
                          state.addressPosition?.latitude ?? 0.0,
                          state.addressPosition?.longitude ?? 0.0,
                        ),
                        zoom: 15,
                      )
                    : _initialPosition,
                mapType: MapType.normal,
                myLocationEnabled: widget.autoDetectMyLocation,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onTap: (LatLng tappedPoint) async {
                  context.read<ChargingStationBloc>().add(
                    HandleMapTapEvent(tappedPoint),
                  );
                },

                onMapCreated: (GoogleMapController controller) async {
                  _mapController = controller;

                  if (widget.autoDetectMyLocation == true) {
                    context.read<ChargingStationBloc>().add(
                      GoToMyLocationEvent(),
                    );
                  }
                  if (widget.autoDetectMyLocation == false &&
                      widget.findOnMapLocation == true) {
                    context.read<ChargingStationBloc>().add(
                      ChooseLocationOnMapEvent(),
                    );
                  }
                },
                markers: state.addressPosition == null
                    ? {}
                    : {
                        Marker(
                          markerId: const MarkerId('selected_point'),
                          position: LatLng(
                            state.addressPosition?.latitude ?? 0.0,
                            state.addressPosition?.longitude ?? 0.0,
                          ),
                          infoWindow: InfoWindow(
                            title: state.address,
                          ),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueAzure,
                          ),
                        ),
                      },
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (state.address != null)
                          Expanded(
                            child: WattMainButton(
                              label: 'Save',
                              onPressed: () {
                                context.read<ChargingStationBloc>().add(
                                  SaveAddressPropertyEvent(
                                    state.address ?? "",
                                    state.addressPosition,
                                  ),
                                );
                                searchController.clear();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        const SizedBox(width: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.appColors.background,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: context.theme.appColors.onSecondary
                                    .withAlpha(
                                      38,
                                    ),
                                spreadRadius: 0,
                                blurRadius: 15,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(5),
                            child: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: () {
                                context.read<ChargingStationBloc>().add(
                                  GoToMyLocationEvent(),
                                );

                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () {
                                    _mapController?.showMarkerInfoWindow(
                                      const MarkerId('selected_point'),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).viewPadding.top + 75,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _focusNode.unfocus();
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).viewPadding.top,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    SearchBarWidget(
                      onLeadingPressed: () {
                        searchController.clear();
                        context.read<ChargingStationBloc>().add(
                          ClearAddressPropertyEvent(),
                        );
                        Navigator.of(context).pop();
                      },
                      context: context,
                      focusNode: _focusNode,
                      onFocusChange: (hasFocus) {
                        setState(() {
                          showSuggestions = hasFocus;
                        });
                      },

                      controller: searchController,
                      mapController: _mapController,
                      onChanged: (value) {
                        context.read<ChargingStationBloc>().add(
                          FetchLocationSuggestionsEvent(value),
                        );
                      },
                      onIconPressed: () {
                        searchController.clear();
                        context.read<ChargingStationBloc>().add(
                          ClearAddressPropertyEvent(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              if (showSuggestions && suggestions.isNotEmpty)
                Positioned(
                  top: 108,
                  left: 85,
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
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = suggestions[index];

                          return ListTile(
                            leading: const Icon(
                              Icons.location_on_outlined,
                            ),
                            title: Text(suggestion),
                            onTap: () {
                              searchController.text = suggestion;
                              setState(() {
                                showSuggestions = false;
                              });
                              _focusNode.unfocus();

                              context.read<ChargingStationBloc>().add(
                                SearchLocationEvent(
                                  suggestion,
                                  _mapController,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
