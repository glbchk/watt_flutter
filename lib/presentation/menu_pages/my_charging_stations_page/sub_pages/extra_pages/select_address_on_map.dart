import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/presentation/menu_pages/my_charging_stations_page/bloc/my_charging_stations_cubit.dart';
import 'package:watt/presentation/menu_pages/my_charging_stations_page/bloc/my_charging_stations_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/search_bar_widget.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class SelectAddressOnMapPage extends StatefulWidget {
  final bool autoDetectMyLocation;
  final bool findOnMapLocation;

  const SelectAddressOnMapPage({
    super.key,
    this.autoDetectMyLocation = false,
    this.findOnMapLocation = false,
  });

  @override
  State<SelectAddressOnMapPage> createState() => _SelectAddressOnMapPageState();
}

class _SelectAddressOnMapPageState extends State<SelectAddressOnMapPage> {
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool showSuggestions = false;
  Timer? _debounce;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(52.157902, -106.6701577), // Example: Saskatoon
    zoom: 13,
  );

  GoogleMapController? _mapController;

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyChargingStationsCubit, MyChargingStationsState>(
      listener: (context, state) {
        if (state.chargingStation?.addressLatitude != null &&
            state.chargingStation?.addressLongitude != null &&
            state.chargingStation?.address != null) {
          final latLng = LatLng(
            state.chargingStation?.addressLatitude ?? 0.0,
            state.chargingStation?.addressLongitude ?? 0.0,
          );

          final newAddress = state.chargingStation?.address ?? "";

          if (searchController.text != newAddress) {
            searchController.text = newAddress;
            searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: newAddress.length),
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
          leading: BackButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                final newAddress = searchController.text;

                context.read<MyChargingStationsCubit>().saveAddress(
                  state.chargingStation?.address ?? newAddress,
                  state.chargingStation?.addressLatitude,
                  state.chargingStation?.addressLongitude,
                );
              }

              Navigator.pop(context);
            },
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition:
                    state.chargingStation?.addressLatitude != null &&
                        state.chargingStation?.addressLongitude != null
                    ? CameraPosition(
                        target: LatLng(
                          state.chargingStation?.addressLatitude ?? 0.0,
                          state.chargingStation?.addressLongitude ?? 0.0,
                        ),
                        zoom: 15,
                      )
                    : _initialPosition,
                mapType: MapType.normal,
                myLocationEnabled: widget.autoDetectMyLocation,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onTap: (LatLng tappedPoint) async {
                  context.read<MyChargingStationsCubit>().handleMapTap(
                    tappedPoint,
                  );
                },

                onMapCreated: (GoogleMapController controller) async {
                  _mapController = controller;

                  if (widget.autoDetectMyLocation == true) {
                    context.read<MyChargingStationsCubit>().goToMyLocation();
                  }
                  if (widget.autoDetectMyLocation == false &&
                      widget.findOnMapLocation == true) {
                    context
                        .read<MyChargingStationsCubit>()
                        .chooseLocationOnMap();
                  }
                },
                markers:
                    state.chargingStation?.addressLatitude != null &&
                        state.chargingStation?.addressLongitude != null
                    ? {
                        Marker(
                          markerId: const MarkerId('selected_point'),
                          position: LatLng(
                            state.chargingStation!.addressLatitude!,
                            state.chargingStation!.addressLongitude!,
                          ),
                          infoWindow: InfoWindow(
                            title: state.chargingStation?.address,
                          ),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueAzure,
                          ),
                        ),
                      }
                    : {},
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
                        if (state.chargingStation?.address != null)
                          Expanded(
                            child: WattMainButton(
                              label: 'Save',
                              onPressed: () {
                                if (searchController.text.isNotEmpty) {
                                  context
                                      .read<MyChargingStationsCubit>()
                                      .saveAddress(
                                        state.chargingStation?.address ??
                                            searchController.text,
                                        state.chargingStation?.addressLatitude,
                                        state.chargingStation?.addressLongitude,
                                      );
                                }

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
                                context
                                    .read<MyChargingStationsCubit>()
                                    .goToMyLocation();

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
                        if (searchController.text.isNotEmpty) {
                          context.read<MyChargingStationsCubit>().saveAddress(
                            state.chargingStation?.address ??
                                searchController.text,
                            state.chargingStation?.addressLatitude,
                            state.chargingStation?.addressLongitude,
                          );
                        }
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
                        _debounce?.cancel();
                        _debounce = Timer(
                          const Duration(milliseconds: 500),
                          () {
                            context
                                .read<MyChargingStationsCubit>()
                                .fetchLocationSuggestions(value);
                          },
                        );
                      },
                      onIconPressed: () {
                        searchController.clear();
                        context.read<MyChargingStationsCubit>().clearAddress();
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

                              context
                                  .read<MyChargingStationsCubit>()
                                  .searchMyLocation(
                                    suggestion,
                                    _mapController,
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
