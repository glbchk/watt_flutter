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
import 'package:watt/utils/global_methods/google_maps_helper_methods.dart';

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

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(51.5074, -0.1278), // Example: London
    zoom: 12,
  );

  GoogleMapController? _mapController;

  LatLng? _selectedLocation;

  String address = '';

  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ChargingStationBloc>();

    _subscription = bloc.stream.listen((state) {
      if (state.addressPosition != null && _mapController != null) {
        final latLng = LatLng(
          state.addressPosition!.latitude,
          state.addressPosition!.longitude,
        );

        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 15),
        );

        _mapController!.showMarkerInfoWindow(
          const MarkerId('selected_point'),
        );

        searchController.text = state.address ?? '';
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChargingStationBloc, ChargingStationState>(
      listener: (context, state) {
        // if (state.addressPosition != null) {
        //   final latLng = LatLng(
        //     state.addressPosition?.latitude ?? 0.0,
        //     state.addressPosition?.longitude ?? 0.0,
        //   );
        //
        //   searchController.text = state.address ?? "";
        //
        //   if (_mapController != null) {
        //     _mapController
        //         ?.animateCamera(
        //           CameraUpdate.newLatLngZoom(latLng, 15),
        //         )
        //         .then((_) {
        //           Future.delayed(const Duration(milliseconds: 300), () {
        //             _mapController?.showMarkerInfoWindow(
        //               const MarkerId('selected_point'),
        //             );
        //           });
        //         });
        //   }
        // }
      },
      builder: (context, state) {
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
                  // final tappedAddress =
                  //     await GoogleMapsHelperMethods.handleMapTap(
                  //       tappedPoint: tappedPoint,
                  //     );
                  //
                  // _mapController?.showMarkerInfoWindow(
                  //   const MarkerId('selected_point'),
                  // );

                  // setState(() {
                  //   _selectedLocation = tappedPoint;
                  //   this.address = tappedAddress ?? '';
                  //   searchController.text = tappedAddress ?? '';
                  // });
                },

                onMapCreated: (GoogleMapController controller) async {
                  _mapController = controller;

                  if (widget.autoDetectMyLocation == true) {
                    context.read<ChargingStationBloc>().add(
                      GoToMyLocationEvent(),
                    );

                    Future.delayed(const Duration(milliseconds: 100), () {
                      _mapController?.showMarkerInfoWindow(
                        const MarkerId('selected_point'),
                      );
                    });

                    // setState(() {
                    //   _selectedLocation = LatLng(
                    //     state.addressPosition?.latitude ?? 0.0,
                    //     state.addressPosition?.longitude ?? 0.0,
                    //   );
                    // });
                    // searchController.text = state.address ?? '';
                    // Future.delayed(const Duration(milliseconds: 100), () {
                    //   _mapController?.showMarkerInfoWindow(
                    //     const MarkerId('selected_point'),
                    //   );
                    // });
                  }
                  if (widget.autoDetectMyLocation == false &&
                      widget.findOnMapLocation == true) {
                    await GoogleMapsHelperMethods.extractMyCityLocation(
                      mapController: _mapController,
                      onLocationFound: (location, formattedAddress) {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _mapController?.showMarkerInfoWindow(
                            const MarkerId('selected_point'),
                          );
                        });

                        // setState(() {
                        //   _selectedLocation = location;
                        // });
                      },
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

                                // setState(() {
                                //   _selectedLocation = LatLng(
                                //     state.addressPosition?.latitude ?? 0.0,
                                //     state.addressPosition?.longitude ?? 0.0,
                                //   );
                                // });
                                // searchController.text = state.address ?? '';
                                // Future.delayed(
                                //   const Duration(milliseconds: 100),
                                //   () {
                                //     _mapController?.showMarkerInfoWindow(
                                //       const MarkerId('selected_point'),
                                //     );
                                //   },
                                // );
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
                top: MediaQuery.of(context).viewPadding.top,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    SearchBarWidget(
                      onBackPressed: () {
                        // setState(() {
                        //   _selectedLocation = null;
                        // });
                        // searchController.clear();
                        context.read<ChargingStationBloc>().add(
                          ClearAddressPropertyEvent(),
                        );
                        Navigator.of(context).pop();
                      },
                      context: context,
                      controller: searchController,
                      mapController: _mapController,
                      onSubmitted: (value) {
                        context.read<ChargingStationBloc>().add(
                          SearchLocationEvent(
                            value,
                            _mapController,
                          ),
                        );
                        // Future.delayed(const Duration(milliseconds: 100), () {
                        //   _mapController?.showMarkerInfoWindow(
                        //     const MarkerId('selected_point'),
                        //   );
                        // });
                        // setState(() {
                        //   _selectedLocation = LatLng(
                        //     state.addressPosition?.latitude ?? 0.0,
                        //     state.addressPosition?.longitude ?? 0.0,
                        //   );
                        // });
                        // searchController.text = state.address ?? '';
                      },
                      onIconPressed: () {
                        // setState(() {
                        //   _selectedLocation = null;
                        // });

                        context.read<ChargingStationBloc>().add(
                          ClearAddressPropertyEvent(),
                        );
                        searchController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
